AssetUtils = _u.getUtils 'asset'
config = require '../../config/environment'
redisClient = require '../../common/redisClient'

imageHost             = config.assetHost.images
videoHost             = config.assetHost.videos
slideHost             = config.assetHost.slides
uploadSlideHost       = config.assetHost.uploadSlide
uploadImageHost       = config.assetHost.uploadImage
uploadVideoHost       = config.assetHost.uploadVideo

retrieveAsset = (key, assetHost, res) ->

  # check cache first
  redisClient.q.get key
  .then (cached) ->
    if cached? then return res.redirect cached

    logger.info "No cache found for #{key}"
    logger.info 'Asset host is ' + assetHost
    switch assetHost
      when 'qiniu'
        AssetUtils.getAssetFromQiniu key, res
      when 's3'
        AssetUtils.getAssetFromS3 key, res
      when 'azure'
        AssetUtils.getAssetFromAzure key, res
      else
        res.send 404, 'asset host not found'


uploadAsset = (assetHost, req, res) ->

  fileName = req.query.fileName

  switch assetHost
    when 'qiniu'
      console.log 'upload host is qiniu'
      params = AssetUtils.genQiniuUpParams fileName
      res.send 200, params
    when 's3'
      console.log 'upload host is S3'
      params = AssetUtils.genS3UpParams fileName
      res.send 200, params
    when 'azure'
      console.log 'upload host is Azure'
      AssetUtils.genAzureUpParams(fileName)
      .done (params)->
        res.send 200, params
      , (err) ->
        res.send 404, err
#      location = AssetUtils.genAzureUpLocation fileName
#      res.send 200, location
    else
      res.send 404, "Asset host #{assetHost} not found"


###
  redirect api/assets/images/key to asset host URL
###
exports.getImages = (req, res) ->
  key = decodeURI(req.url.replace(/(\/|)images\//, ''))
  logger.info 'Key is ' + key
  retrieveAsset key, imageHost, res

exports.getVideos = (req, res) ->
  key = decodeURI(req.url.replace(/(\/|)videos\//, ''))
  logger.info 'Key is ' + key
  retrieveAsset key, videoHost, res

exports.getSlides = (req, res) ->
  key = decodeURI(req.url.replace(/(\/|)slides\//, ''))
  logger.info 'Key is ' + key
  retrieveAsset key, slideHost, res


exports.uploadImage = (req, res) ->
  uploadAsset uploadImageHost, req, res

exports.uploadVideo = (req, res) ->
  uploadAsset uploadVideoHost, req, res

exports.uploadSlide = (req, res) ->
  uploadAsset uploadSlideHost, req, res

