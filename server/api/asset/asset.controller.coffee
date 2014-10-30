AssetUtils = _u.getUtils 'asset'
config = require '../../config/environment'
redisClient = require '../../common/redisClient'

uploadSlideHost       = config.assetsConfig[config.assetHost.uploadSlideType].serviceName
uploadImageHost       = config.assetsConfig[config.assetHost.uploadImageType].serviceName
uploadVideoHost       = config.assetsConfig[config.assetHost.uploadVideoType].serviceName
uploadSlideType       = config.assetHost.uploadSlideType
uploadImageType       = config.assetHost.uploadImageType
uploadVideoType       = config.assetHost.uploadVideoType

retrieveAsset = (key, assetType, res) ->

  # check cache first
  redisClient.q.get key
  .then (cached) ->
    if cached? then return cached

    logger.info "No cache found for #{key}"
    logger.info 'Asset type ' + assetType
    switch config.assetsConfig[assetType].serviceName
      when 'qiniu'
        AssetUtils.getAssetFromQiniu key, assetType
      when 's3'
        AssetUtils.getAssetFromS3 key, assetType
      when 'azure'
        AssetUtils.getAssetFromAzure key, assetType
      else
        throw new Error('asset host not found')


uploadAsset = (assetType, fileName) ->
  switch config.assetsConfig[assetType].serviceName
    when 'qiniu'
      console.log 'upload host is qiniu'
      AssetUtils.genQiniuUpParams assetType, fileName
    when 's3'
      console.log 'upload host is S3'
      AssetUtils.genS3UpParams assetType, fileName
    when 'azure'
      console.log 'upload host is Azure'
      AssetUtils.genAzureUpParams assetType, fileName
    else
      throw new Error("Asset host #{assetHost} not found")

###
  redirect api/assets/images/key to asset host URL
###
exports.getImages = (req, res, next) ->
  key = decodeURI(req.url.replace(/(\/|)images\/\d+\//, ''))
  assetType = req.params.assetType

  retrieveAsset key, assetType
  .then (downloadUrl)->
    res.redirect downloadUrl
  .catch next
  .done()

exports.getVideos = (req, res, next) ->
  key = decodeURI(req.url.replace(/(\/|)videos\/\d+\//, ''))
  assetType = req.params.assetType

  retrieveAsset key, assetType
  .then (downloadUrl)->
    res.redirect downloadUrl
  .catch next
  .done()

exports.getSlides = (req, res, next) ->
  key = decodeURI(req.url.replace(/(\/|)slides\/\d+\//, ''))
  assetType = req.params.assetType

  retrieveAsset key, assetType
  .then (downloadUrl)->
    res.redirect downloadUrl
  .catch next
  .done()


exports.uploadImage = (req, res, next) ->
  uploadAsset uploadImageType, req.query.fileName
  .then (data)->
    data.prefix = "/api/assets/images/#{uploadImageType}/"
    res.send data
  .catch next
  .done()

exports.uploadVideo = (req, res, next) ->
  uploadAsset uploadVideoType, req.query.fileName
  .then (data)->
    data.prefix = "/api/assets/videos/#{uploadVideoType}/"
    res.send data
  .catch next
  .done()

exports.uploadSlide = (req, res, next) ->
  uploadAsset uploadSlideType, req.query.fileName
  .then (data)->
    data.prefix = "/api/assets/slides/#{uploadSlideType}/"
    res.send data
  .catch next
  .done()