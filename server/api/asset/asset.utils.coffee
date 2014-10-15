BaseUtils = require('../../common/BaseUtils').BaseUtils
qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'
AWS = require 'aws-sdk'
moment = require 'moment'
crypto = require 'crypto'
redisClient = require '../../common/redisClient'
request = require 'request'
redislock = require 'redislock'
#request = request.defaults proxy: config.proxy if config.proxy?

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
signedUrlExpires      = config.qiniu.signed_url_expires

AWS.config.accessKeyId     = config.s3.accessKeyId
AWS.config.secretAccessKey = config.s3.secretAccessKey
AWS.config.region          = config.s3.region
AWSAlgorithm         = config.s3.algorithm

acsBaseAddress = config.azure.acsBaseAddress

Lecture = _u.getModel 'lecture'

exports.AssetUtils = BaseUtils.subclass
  classname: 'AssetUtils'

  getAssetFromQiniu : (key, assetType, res) ->
    domain = config.assetsConfig[assetType].domain

    baseUrl = qiniu.rs.makeBaseUrl domain, key.split('?')[0]

    # the query should not encode before signature
    baseUrl += if key.split('?')[1] then ('?' + key.split('?')[1]) else ''
    policy = new qiniu.rs.GetPolicy(signedUrlExpires)
    downloadUrl = policy.makeRequest(baseUrl)

    # cache expiration is one hour less than signedURL expiration from qiniu
    redisClient.q.set key, downloadUrl, 'EX', (signedUrlExpires-60*60)
    .then (result) ->
      logger.info "Set #{key}:#{downloadUrl} to redis"
    res.redirect downloadUrl


  getAssetFromS3 : (key, assetType, res) ->
    S3BucketName = config.assetsConfig[assetType].slideBucket

    s3 = new AWS.S3()
    params =
      Bucket : S3BucketName
      Key : key
      Expires : signedUrlExpires

    # use s3 SDK to sign URL
    s3.getSignedUrl 'getObject', params, (err, url) ->
      if err
        return res.send 500, 'Failed to sign URL for S3 asset'

      logger.info 'Signed S3 URL is ' + url
      redisClient.q.set key, url, 'EX', (signedUrlExpires-60*60)
      .then (result) ->
        logger.info "Set #{key}:#{url} to redis"
      res.redirect url


  # TODO: need to add lock. Try Distributed locks with Redis?
  getAssetFromAzure : (key, assetType, res) ->
    tk_fn = key.split '/'
    assetId = tk_fn[0]
    fileName = tk_fn[1]

    access_token = null
    policyId = null
    locatorId = null
    lecture = null
    downloadUrl = null
    requestPostQ = Q.nfbind request.post
    requestDeleteQ = Q.nfbind request.del

    azureAccountName = config.assetsConfig[assetType].accountName
    azureAccountKey = config.assetsConfig[assetType].accountKey

    lock = redislock.createLock redisClient, {timeout: 20000, retries: 3, delay: 100}
    lock.acquire assetId # don't use "key" as lock name... otherwise, it will be overwrote by redis cache in step 6
    .then ()->
      logger.info "lock: "+ key + "required!"
      Lecture.findOneQ "media": '/api/assets/videos/'+assetType+'/'+key
    .then (data) ->
      lecture = data
      throw "no lecture found" if not lecture
    # 1. get token
      requestPostQ {
        uri: acsBaseAddress
        form:
          grant_type: 'client_credentials'
          client_id: azureAccountName
          client_secret: azureAccountKey
          scope: 'urn:WindowsAzureMediaServices'
        strictSSL: true
      }
    .then (response) ->
      access_token = JSON.parse(response[0].body).access_token
      logger.info  "access_token:", access_token
    # 2.1 delete previous Locator
      if lecture.locatorId
        requestDeleteQ {
          uri: config.azure.shaAPIServerAddress+"Locators('#{lecture.locatorId}')"
          headers: config.azure.defaultHeaders(access_token)
          strictSSL: true
        }
    .then (response) ->
    # 2.2 delete previous read access policy
      if lecture.accessPolicyId
        requestDeleteQ {
          uri: config.azure.shaAPIServerAddress+"AccessPolicies('#{lecture.accessPolicyId}')"
          headers: config.azure.defaultHeaders(access_token)
          strictSSL: true
        }
    .then (response) ->
    # 3. get read access policy
      requestPostQ {
        uri: config.azure.shaAPIServerAddress+'AccessPolicies'
        headers: config.azure.defaultHeaders(access_token)
        body:  JSON.stringify
          "Name": 'DownloadPolicy',
          "DurationInMinutes" : config.azure.signed_url_expires,
          "Permissions" : 1
        strictSSL: true
      }
    .then (response) ->
    # 4. get download url
      policyId = JSON.parse(response[0].body).d.Id
      lecture.accessPolicyId = policyId
      requestPostQ {
        uri: config.azure.shaAPIServerAddress+'Locators'
        headers: config.azure.defaultHeaders(access_token)
        body:  JSON.stringify {
          AccessPolicyId : policyId
          AssetId : assetId,
          StartTime : moment.utc().subtract(10, 'minutes').format('M/D/YYYY hh:mm:ss A')
          Type : 1
        }
        strictSSL: true
      }
    .then (response) ->
      locatorId = JSON.parse(response[0].body).d.Id
      lecture.locatorId = locatorId
      downloadUrl = JSON.parse(response[0].body).d.Path.replace('?','/'+fileName+'?')
    # 5 save locatorId &  AccessPolicyId to DB
      lecture.saveQ()
    .then ()->
    # 6 cache to redis
      redisClient.q.set key, downloadUrl, 'EX', (config.azure.signed_url_expires*60-60*60)
    .then () ->
      logger.info "Set #{key}:#{downloadUrl} to redis"
      lock.release()
    .done () ->
      logger.info "locker #{assetId} released"
      logger.info downloadUrl
      res.redirect downloadUrl
    , (err) ->
      logger.error err
      res.send 404, err


  genQiniuUpParams : (assetType, fileName) ->
    qiniuBucketName = config.assetsConfig[assetType].bucket_name

    putPolicy = new qiniu.rs.PutPolicy qiniuBucketName
    token = putPolicy.token()
    randomStr = randomstring.generate 10

    Q {
      url : 'http://up.qiniu.com'
      formData :
        key : randomStr + '/' + fileName
        token : token
      fileFormName : 'file'
    }

  genS3UpParams : (assetType, fileName) ->
    S3UploadBucketName = config.assetsConfig[assetType].slideUploadBucket

    currentDate = moment().format 'YYYYMMDD'
    xAmzCredential = AWS.config.accessKeyId + '/' + currentDate +
      '/' + AWS.config.region + '/s3/aws4_request'
    currentTime = moment()

    # AWS only takes something like 20120325T120000Z
    xAmzDate = currentTime.utc().format 'YYYYMMDDTHHmmss'
    xAmzDate += 'Z'

    xAmzAlgorithm = AWSAlgorithm
    keyStartsWith = randomstring.generate 10

    policy =
      expiration : currentTime.add
        hours : 1   # expires in one hour
      conditions :
        [
          acl : 'private'
        ,
          ['starts-with', '$key', keyStartsWith]
        ,
          bucket : S3UploadBucketName
        ,
          success_action_redirect : ''
        ,
          'x-amz-credential' : xAmzCredential
        ,
          'x-amz-algorithm' : xAmzAlgorithm
        ,
          'x-amz-date' : xAmzDate
        ]

    # following signature algorithm is based on
    # http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-authentication-HTTPPOST.html
    policyStr = JSON.stringify policy
    console.log 'Policy is ' + policyStr

    base64Policy = new Buffer(policyStr).toString 'base64'

    kSecret = 'AWS4' + AWS.config.secretAccessKey

    kDate = crypto.createHmac 'sha256', new Buffer(kSecret)
    .update(xAmzDate.substring(0,8))
    .digest()

    kRegion = crypto.createHmac 'sha256', kDate
    .update(AWS.config.region)
    .digest()

    kService = crypto.createHmac 'sha256', kRegion
    .update('s3')
    .digest()

    kSigning = crypto.createHmac 'sha256', kService
    .update('aws4_request')
    .digest()

    signature = crypto.createHmac 'sha256', kSigning
    .update(base64Policy)
    .digest('hex')

    console.log 'signature is ' + signature

    Q {
      url : 'http://s3.'+ AWS.config.region + ".amazonaws.com.cn/" + S3UploadBucketName
      formData :
        key : keyStartsWith + '/' + fileName
        acl : 'private'
        success_action_redirect : ''
        policy : base64Policy
        'X-Amz-Credential' : xAmzCredential
        'X-Amz-Algorithm' : xAmzAlgorithm
        'X-Amz-Date' : xAmzDate
        'X-Amz-Signature' : signature
      fileFormName : 'file'
    }

  genAzureUpParams : (assetType, fileName) ->
    access_token = null
    assetId = null
    policyId = null
    postQ = Q.nfbind request.post
    azureAccountName = config.assetsConfig[assetType].accountName
    azureAccountKey = config.assetsConfig[assetType].accountKey

    # 1. get token
    postQ {
      uri: config.azure.acsBaseAddress
      form:
        grant_type: 'client_credentials'
        client_id: azureAccountName
        client_secret: azureAccountKey
        scope: 'urn:WindowsAzureMediaServices'
      strictSSL: true
    }
    .then (res) ->
      access_token = JSON.parse(res[0].body).access_token
      logger.info  "access_token:", access_token
      # 2. create Asset
      postQ {
        uri: config.azure.shaAPIServerAddress+'Assets'
        headers: config.azure.defaultHeaders(access_token)
        body:  JSON.stringify "Name": fileName
        strictSSL: true
      }
    .then (res) ->
      assetId = JSON.parse(res[0].body).d.Id
      # 3. create write policy
      postQ {
        uri: config.azure.shaAPIServerAddress+'AccessPolicies'
        headers: config.azure.defaultHeaders(access_token)
        body:  JSON.stringify {"Name": fileName+'writePolicy', "DurationInMinutes" : "300", "Permissions" : 2}
        strictSSL: true
      }
    .then (res) ->
      policyId = JSON.parse(res[0].body).d.Id
      # 4. create upload url
      postQ {
        uri: config.azure.shaAPIServerAddress+'Locators'
        headers: config.azure.defaultHeaders(access_token)
        body:  JSON.stringify {
          AssetId: assetId
          AccessPolicyId : policyId
          StartTime: moment.utc().subtract(10, 'minutes').format('M/D/YYYY hh:mm:ss A')
          Type: 1
        }
      }
    .then (res) ->
      {
        url: JSON.parse(res[0].body).d.Path.replace('?','/'+fileName+'?')
        key: [assetId, fileName].join('/')
      }
