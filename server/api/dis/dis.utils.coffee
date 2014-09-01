BaseUtils = require('../../common/BaseUtils').BaseUtils

exports.DisUtils = BaseUtils.subclass
  classname: 'DisUtils'

  vote: (DisModel, disId, userId) ->
    DisModel.findByIdQ disId
    .then (dis) ->
      if dis.voteUpUsers.indexOf(userId) > -1
        dis.voteUpUsers.pull userId
      else
        dis.voteUpUsers.addToSet userId

      do dis.saveQ
