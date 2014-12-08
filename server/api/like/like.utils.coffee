BaseUtils = require('../../common/BaseUtils')

#SocketUtils = _u.getUtils 'socket'
#NoticeUtils = _u.getUtils 'notice'

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

exports.Instance = new LikeUtils()
exports.Class = LikeUtils
