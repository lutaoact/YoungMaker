BaseUtils = require('../../common/BaseUtils').BaseUtils
qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'
cache = require 'memory-cache'
AWS = require 'aws-sdk'
moment = require 'moment'
crypto = require 'crypto'


qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
domain                = config.qiniu.domain
qiniuBucketName       = config.qiniu.bucket_name
signedUrlExpires      = config.qiniu.signed_url_expires

AWS.config.accessKeyId     = config.aws.accessKeyId
AWS.config.secretAccessKey = config.aws.secretAccessKey
AWS.config.region          = config.aws.region
S3BucketName          = config.aws.slideBucket
AWSAlgorithm         = config.aws.algorithm

exports.AssetUtils = BaseUtils.subclass
  classname: 'AssetUtils'

  getAssetFromQiniu : (key, res) ->
    baseUrl = qiniu.rs.makeBaseUrl domain, key.split('?')[0]

    # the query should not encode before signature
    baseUrl += if key.split('?')[1] then ('?' + key.split('?')[1]) else ''
    policy = new qiniu.rs.GetPolicy(signedUrlExpires)
    downloadUrl = policy.makeRequest(baseUrl)

    # cache expiration is one hour less than signedURL expiration from qiniu
    cache.put key, downloadUrl,  (signedUrlExpires-60*60)*1000
    res.redirect downloadUrl


  getAssetFromS3 : (key, res) ->

    s3 = new AWS.S3()
    params =
      Bucket : S3BucketName
      Key : key
      Expires : signedUrlExpires

    # use s3 SDK to sign URL
    s3.getSignedUrl 'getObject', params, (err, url) ->
      if err
        console.dir err
        return res.send 500, 'Failed to sign URL for S3 asset'

      logger.info 'Signed S3 URL is ' + url
      cache.put key, url, (signedUrlExpires-60*60)*1000
      res.redirect url


  genQiniuUpParams : (fileName) ->
    putPolicy = new qiniu.rs.PutPolicy qiniuBucketName
    token = putPolicy.token()
    randomStr = randomstring.generate 10

    {
      key : randomStr + '/' + fileName
      token : token
      url : 'http://up.qiniu.com'
      fileFormName : 'file'
    }

  genS3UpParams : (fileName) ->

    currentDate = moment().format 'YYYYMMDD'
    xAmzCredential = AWS.config.accessKeyId + '/' + currentDate +
      '/' + AWS.config.region + '/s3/aws4_request'
    currentTime = moment()
    xAmzDate = currentTime.toISOString()

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
          bucket : S3BucketName
        ,
          success_action_redirect : ''
        ,
          'x-amz-credential' : xAmzCredential
        ,
          'x-amz-algorithm' : xAmzAlgorithm
        ,
          'x-amz-date' : xAmzDate
        ]

    policyStr = JSON.stringify policy
    console.log 'Policy is ' + policyStr

    base64Policy = new Buffer(policyStr).toString 'base64'

    signature = crypto.createHmac('sha256', AWS.config.secretAccessKey)
    .update(base64Policy)
    .digest('base64')

    {
      url : 'http://'+ S3BucketName + ".s3.amazonaws.com.cn"
      key : keyStartsWith + '/' + fileName
      acl : 'private'
      success_action_redirect : ''
      policy : base64Policy
      'X-Amz-Credential' : xAmzCredential
      'X-Amz-Algorithm' : xAmzAlgorithm
      'X-Amz-Date' : xAmzDate
      'X-Amz-Signature' : signature
      keyStartsWith : keyStartsWith
    }
