BaseUtils = require('../../common/BaseUtils').BaseUtils
jwt = require('jsonwebtoken')

exports.SocketUtils = BaseUtils.subclass
  classname: 'SocketUtils'

  verify: (token, cb) ->
    deferred = do Q.defer
    jwt.verify token, config.secrets.session, null, (err, user) ->
      if err then deferred.reject err else deferred.resolve user

    return deferred.promise.nodeify cb


  $buildErrMsg: (err) ->
    util = require 'util'
    return JSON.stringify(
      type: 'error'
      payload:
        status: 401
        errMsg: util.inspect err
    )

  $quizMsg: (question) ->
    return JSON.stringify(
      type: 'quiz'
      payload: question
    )


  $sendToGroup: (msg, userIds) ->
    for userId in userIds
      @sendToOne msg, userId


  $sendToOne: (msg, userId) ->
    unless global.socketMap[userId]?
      return logger.warn "userId: #{userId}, socket does not exists"

    global.socketMap[userId].ws.write msg
