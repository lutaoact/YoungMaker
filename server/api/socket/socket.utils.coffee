BaseUtils = require('../../common/BaseUtils').BaseUtils
jwt = require('jsonwebtoken')

exports.SocketUtils = BaseUtils.subclass
  classname: 'SocketUtils'

  verify: (token, cb) ->
    deferred = do Q.defer
    jwt.verify token, config.secrets.session, null, (err, user) ->
      if err then deferred.reject err else deferred.resolve user

    return deferred.promise.nodeify cb

  $_buildMsg: (type, data) ->
    return JSON.stringify type: type payload: data

  $buildErrMsg: (err) ->
    util = require 'util'
    return @_buildMsg 'error', {status: 401, errMsg: util.inspect err}

  $sendNotices: (notices...) ->
    for notice in _.flatten notices
      @sendToOne notice.userId, 'notice', notice

  $sendQuizMsg: (answers, question, teacherId) ->
    for answer in answers
      @sendToOne(
        answer.userId
        'quiz'
        answer:answer, question:question, teacherId: teacherId
      )

  $sendQuizAnswerMsg: (userId, answer) ->
    @sendToOne userId, 'quiz_answer', answer

  $sendToGroup: (userIds, msg) ->
    for userId in userIds
      @sendToOne userId, msg


  $sendToOne: (userId, type, payload) ->
    unless global.socketMap[userId]?
      return logger.warn "userId: #{userId}, socket does not exists"

    global.socketMap[userId].ws.write @_buildMsg(type, payload)
