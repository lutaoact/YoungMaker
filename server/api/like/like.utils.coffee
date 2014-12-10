BaseUtils = require('../../common/BaseUtils')

class LikeUtils extends BaseUtils
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
    return conditions

  getAllForPage: (Model, conditions, options) ->
    return Model.find((_.extend conditions, {deleteFlag: {$ne: true}}), '-deleteFlag')
    .sort created: -1
    .limit options.limit ? Const.PageSize[Model.constructor.name]#Article or Course
    .skip options.from
    .populate 'author', 'name'
    .execQ()

  getCountAndPageInfo: (Model, conditions, from) ->
    return Q.all [
      @getAllForPage Model, conditions, from
      Model.countQ conditions
    ]

exports.Instance = new LikeUtils()
exports.Class = LikeUtils
