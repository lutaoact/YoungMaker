AssetUtils = _u.getUtils 'asset'
config = require '../../config/environment'
cache = require 'memory-cache'

imageHost             = config.assetHost.images
videoHost             = config.assetHost.videos
slideHost             = config.assetHost.slides
uploadSlideHost       = config.assetHost.uploadSlide
uploadImageHost       = config.assetHost.uploadImage
uploadVideoHost       = config.assetHost.uploadVideo

###
  redirect api/assets/images/key to asset host URL
###
exports.getImages = (req, res) ->

  # check cache first
  key = decodeURI(req.url.replace(/(\/|)images\//, ''))
  logger.info 'Key is ' + key
  cached = cache.get key
  if cached? then return res.redirect cached

  logger.info 'Image host is ' + imageHost
  switch imageHost
    when 'qiniu'
      AssetUtils.getAssetFromQiniu key, res
    else # only support qiniu for now
      res.send 404, 'asset host not found'


exports.getVideos = (req, res) ->

  # check cache first
  key = decodeURI(req.url.replace(/(\/|)videos\//, ''))
  logger.info 'Key is ' + key
  cached = cache.get key
  if cached? then return res.redirect cached

  logger.info 'Video host is ' + videoHost
  switch videoHost
    when 'qiniu'
      AssetUtils.getAssetFromQiniu key, res
    else # only support qiniu for now
      res.send 404, 'asset host not found'


exports.getSlides = (req, res) ->
  # check cache first
  key = decodeURI(req.url.replace(/(\/|)slides\//, ''))
  logger.info 'Key is ' + key
  cached = cache.get key
  if cached? then return res.redirect cached

  logger.info 'Slide host is ' + slideHost
  switch slideHost
    when 'qiniu'
      AssetUtils.getAssetFromQiniu key, res
    when 's3'
      AssetUtils.getAssetFromS3 key, res
    else # only support qiniu for now
      res.send 404, 'asset host not found'


exports.uploadImage = (req, res) ->
  console.log 'start generating upload image params...'

  fileName = req.query.fileName
  switch uploadImageHost
    when 'qiniu'
      console.log 'upload image host is qiniu'
      params = AssetUtils.genQiniuUpParams fileName
      res.send 200, params
    else
      res.send 404, "Asset host #{uploadImageHost} not found"


exports.uploadVideo = (req, res) ->
  console.log 'start generating upload video params...'
  fileName = req.query.fileName

  switch uploadVideoHost
    when 'qiniu'
      console.log 'upload video host is qiniu'
      params = AssetUtils.genQiniuUpParams fileName
      res.send 200, params
    else
      res.send 404, "Asset host #{uploadVideoHost} not found"


exports.uploadSlide = (req, res) ->
  console.log 'start generating upload slide params...'
  fileName = req.query.fileName

  switch uploadSlideHost
    when 's3'
      console.log 'upload slide host is S3'
      params = AssetUtils.genS3UpParams fileName
      res.send 200, params
    when 'qiniu'
      console.log 'upload slide host is qiniu'
      params = AssetUtils.genQiniuUpParams fileName
      res.send 200, params
    else
      res.send 404, "Asset host #{uploadSlideHost} not found"

