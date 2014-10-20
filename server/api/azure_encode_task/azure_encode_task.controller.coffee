config = require '../../config/environment'
Azure = require 'azure-media'
AzureEncodeTask  = _u.getModel "azure_encode_task"
auth =
  client_id: config.assetsConfig[config.assetHost.uploadVideoType].accountName
  client_secret: config.assetsConfig[config.assetHost.uploadVideoType].accountKey
  base_url: config.azure.bjbAPIServerAddress
  oauth_url: config.azure.acsBaseAddress

exports.create = (req, res, next) ->
  task = {}
  task.inputAssetId = req.body.inputAssetId # "nb:cid:UUID:57d7ef04-e9d3-4d04-b1fc-fd4224da5b06"

  api = new Azure(auth)
  apiInit = Q.nbind(api.init, api)
  apiEncodeVideo = Q.nbind(api.media.encodeVideo, api.media)

  AzureEncodeTask.findOneQ inputAssetId: task.inputAssetId
  .then (res)->
    # TODO: define error code
    console.log res
    throw "cannot create multiple task on the same asset, delete it before create!" if res
    apiInit()
  .then (token)->
    apiEncodeVideo task.inputAssetId, 'H264 Adaptive Bitrate MP4 Set 720p'
  .then (res)->
    task.jobId = res[0].toJSON().Id
    apiListOutputMediaAssets = Q.nbind(api.rest.job.listOutputMediaAssets, api.rest.job)
    apiListOutputMediaAssets task.jobId
  .then (res)->
    task.outputAssetId = res[0].toJSON().Id
    apiListTasks = Q.nbind(api.rest.job.listTasks, api.rest.job)
    apiListTasks task.jobId
  .then (res)->
    task.taskId = res[0].toJSON().Id
    AzureEncodeTask.createQ task
  .then (azure_encode_task) ->
    res.json 201, azure_encode_task
  , (err) ->
    logger.error err
    next err


exports.status = (req, res, next) ->
  inputAssetId = req.query.inputAssetId

  api = new Azure(auth)
  apiInit = Q.nbind(api.init, api)

  task = null
  status = {}
  apiInit()
  .then ()->
    AzureEncodeTask.findOneQ inputAssetId: inputAssetId
  .then (data)->
    task = data
    apiTaskGet = Q.nbind(api.rest.task.get, api.rest.task)
    apiTaskGet task.taskId
  .then (taskStatus)->
    taskStatus = taskStatus.toJSON()
    status.progress = taskStatus.Progress
    status.startTime = taskStatus.StartTime
    status.runningDuration = taskStatus.RunningDuration
    status.endTime = taskStatus.EndTime
    status.state = taskStatus.State # Active = 1, Running = 2, Completed = 3
    if status.state == 3
      status.encodedMedia = "/api/assets/videos/#{config.assetHost.uploadVideoType}/#{task.outputAssetId}/encoded"
  .done ()->
    res.json 201, status
  , next