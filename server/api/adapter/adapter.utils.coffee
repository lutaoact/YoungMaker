BaseUtils = require('../../common/BaseUtils')

class AdapterUtils extends BaseUtils
  like: (Model, objectId, userId) ->
    tmpResult = {}
    Model.findByIdQ objectId
    .then (object) ->
      tmpResult.object = object
      if object.likeUsers.indexOf(userId) > -1
        object.likeUsers.pull userId
      else
        object.likeUsers.addToSet userId
        console.log "userId: #{userId} like #{Model.constructor.name}: #{objectId}"

      do object.saveQ
    .then (result) ->
      tmpResult.newObj = result[0]
      return tmpResult.newObj

  buildConditions: (query) ->
    conditions = {}
    conditions.author = query.author if query.author
    conditions.creator = query.creator if query.creator
    conditions.type = query.type if query.type
    conditions.belongTo = query.belongTo if query.belongTo

    return conditions

  getAllForPage: (Model, conditions, options) ->
    modelName = Model.constructor.name
    return Model.find((_.extend conditions, {deleteFlag: {$ne: true}}), '-deleteFlag')
    .sort created: -1
    .limit options.limit ? Const.PageSize[modelName]#Article or Course
    .skip options.from
    .populate fieldMap[modelName].field, fieldMap[modelName].populate
    .execQ()

  getCountAndPageInfo: (Model, conditions, from) ->
    return Q.all [
      @getAllForPage Model, conditions, from
      Model.countQ conditions
    ]

exports.Instance = new AdapterUtils()
exports.Class = AdapterUtils
