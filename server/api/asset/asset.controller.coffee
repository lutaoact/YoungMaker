
qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'
cache = require 'memory-cache'
path = require 'path'
fs = require 'fs'
http = require 'http'
mediaEvents = require '../../common/media_process_event'
AWS = require 'aws-sdk'

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
domain                = config.qiniu.domain
bucketName            = config.qiniu.bucket_name
signedUrlExpires      = config.qiniu.signed_url_expires
imageHost             = config.assetHost.images
videoHost             = config.assetHost.videos
slideHost             = config.assetHost.slides
AWS.config.accessKeyId     = config.aws.accessKeyId
AWS.config.secretAccessKey = config.aws.secretAccessKey
AWS.config.region          = config.aws.region
S3BucketName          = config.aws.slideBucket


getAssetFromQiniu = (key, res) ->
  baseUrl = qiniu.rs.makeBaseUrl domain, key.split('?')[0]

  # the query should not encode before signature
  baseUrl += if key.split('?')[1] then ('?' + key.split('?')[1]) else ''
  policy = new qiniu.rs.GetPolicy(signedUrlExpires)
  downloadUrl = policy.makeRequest(baseUrl)

  # cache expiration is one hour less than signedURL expiration from qiniu
  cache.put key, downloadUrl,  (signedUrlExpires-60*60)*1000
  res.redirect downloadUrl


getAssetFromS3 = (key, res) ->

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


###
  redirect api/assets/images/key to asset host URL
###
exports.getImages = (req, res, next) ->

  # check cache first
  key = decodeURI(req.url.replace(/(\/|)images\//, ''))
  logger.info 'Key is ' + key
  cached = cache.get key
  if cached? then return res.redirect cached

  logger.info 'Image host is ' + imageHost
  switch imageHost
    when 'qiniu'
      getAssetFromQiniu key, res
    else # only support qiniu for now
      res.send 404, 'asset host not found'


exports.getVideos = (req, res, next) ->

  # check cache first
  key = decodeURI(req.url.replace(/(\/|)videos\//, ''))
  logger.info 'Key is ' + key
  cached = cache.get key
  if cached? then return res.redirect cached

  logger.info 'Video host is ' + videoHost
  switch videoHost
    when 'qiniu'
      getAssetFromQiniu key, res
    else # only support qiniu for now
      res.send 404, 'asset host not found'


exports.getSlides = (req, res, next) ->
  # check cache first
  key = decodeURI(req.url.replace(/(\/|)slides\//, ''))
  logger.info 'Key is ' + key
  cached = cache.get key
  if cached? then return res.redirect cached

  logger.info 'Slide host is ' + slideHost
  switch slideHost
    when 'qiniu'
      getAssetFromQiniu key, res
    when 's3'
      getAssetFromS3 key, res
    else # only support qiniu for now
      res.send 404, 'asset host not found'


exports.upload = (req, res, next) ->
  console.log 'start upload'

  if req.headers.host?
    delete req.headers.host

  req.body.
  request
    url : 'http://up.qiniu.com'
    headers : req.headers

