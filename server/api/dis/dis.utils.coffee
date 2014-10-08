BaseUtils = require('../../common/BaseUtils').BaseUtils

SocketUtils = _u.getUtils 'socket'
NoticeUtils = _u.getUtils 'notice'

exports.DisUtils = BaseUtils.subclass
  classname: 'DisUtils'

  vote: (DisModel, disId, userId) ->
    type = DisModel.classname[-5..] #Reply or Topic
    tmpResult = {}
    DisModel.findByIdQ disId
    .then (dis) ->
      tmpResult.dis = dis
      if dis.voteUpUsers.indexOf(userId) > -1
        dis.voteUpUsers.pull userId
      else
        dis.voteUpUsers.addToSet userId
        NoticeUtils["add#{type}VoteUpNotice"](
          dis.postBy
          userId
          dis._id
        ).then (notice) ->
          SocketUtils.sendNotices notice

      do dis.saveQ
    .then (result) ->
      tmpResult.newDis = result[0]
      return tmpResult.newDis
