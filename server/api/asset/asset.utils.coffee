BaseUtils = require('../../common/BaseUtils')
qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'
AWS = require 'aws-sdk'
moment = require 'moment'
crypto = require 'crypto'
redisClient = require '../../common/redisClient'
request = require 'request'
redislock = require 'redislock'
getMediaService = require('../../common/azureMS').getMediaService

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
signedUrlExpires      = config.qiniu.signed_url_expires

AWS.config.accessKeyId     = config.s3.accessKeyId
AWS.config.secretAccessKey = config.s3.secretAccessKey
AWS.config.region          = config.s3.region
AWSAlgorithm         = config.s3.algorithm

acsBaseAddress = config.azure.acsBaseAddress

class AssetUtils extends BaseUtils
  classname: 'AssetUtils'

  getAssetFromQiniu : (key, assetType) ->
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
      return downloadUrl


  getAssetFromS3 : (key, assetType) ->
    S3BucketName = config.assetsConfig[assetType].slideBucket

    s3 = new AWS.S3()
    params =
      Bucket : S3BucketName
      Key : key
      Expires : signedUrlExpires

    s3GetSignedUrlQ = Q.nbind s3.getSignedUrl, s3
    # use s3 SDK to sign URL
    downloadUrl = null
    s3GetSignedUrlQ 'getObject', params #, (err, url) ->
    .then (url)->
      downloadUrl = url
      logger.info 'Signed S3 URL is ' + url
      redisClient.q.set key, url, 'EX', (signedUrlExpires-60*60)
    .then (result) ->
      logger.info "Set #{key}:#{downloadUrl} to redis"
      return downloadUrl


  getAssetFromAzure : (key, assetType) ->
    tk_fn = key.split '/'
    assetId = tk_fn[0] # origin or encode
    urlType = tk_fn[1]

    downloadUrl = null

    auth =
      client_id: config.assetsConfig[assetType].accountName
      client_secret: config.assetsConfig[assetType].accountKey
      base_url: config.azure.serverAddress
      oauth_url: config.azure.acsBaseAddress

    api = null
    lock = redislock.createLock redisClient, {timeout: 20000, retries: 3, delay: 100}
    lock.acquire assetId
    .then ()->
      logger.info "acquired lock: "+ assetId
      getMediaService(auth)
    .then (azureMediaService)->
      api = azureMediaService
      switch urlType
        when 'origin'
          apiMediaGetDownloadURL = Q.nbind(api.media.getDownloadURL, api.media); # get origin url
        when 'encode'
          apiMediaGetDownloadURL = Q.nbind(api.media.getOriginURL, api.media); # get encoded url
        else
          apiMediaGetDownloadURL = Q.nbind(api.media.getDownloadURL, api.media); # for upward compatibility
      apiMediaGetDownloadURL assetId, config.azure.signed_url_expires
    .then (url) ->
      downloadUrl = url
      redisClient.q.set key, downloadUrl, 'EX', (config.azure.signed_url_expires*60-60*60)
    .then () ->
      logger.info "Set #{key}:#{downloadUrl} to redis"
      logger.info downloadUrl
    .then ()->
      lock.release()
      logger.info "released lock: #{assetId}"
      return downloadUrl

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
    auth =
      client_id: config.assetsConfig[assetType].accountName
      client_secret: config.assetsConfig[assetType].accountKey
      base_url: config.azure.serverAddress
      oauth_url: config.azure.acsBaseAddress

    getMediaService(auth)
    .then (api)->
      apiMediaGetUploadURL = Q.nbind(api.media.getUploadUrl, api.media);
      apiMediaGetUploadURL fileName
    .then (res) ->
      {
        url: res.path
        key: res.assetId + "/origin"
      }

exports.Instance = new AssetUtils()
exports.Classe = AssetUtils
