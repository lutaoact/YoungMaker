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

  $quizMsg: (answer, question, teacherId) ->
    return JSON.stringify(
      type: 'quiz'
      payload:
        answer: answer
        question: question
        teacherId: teacherId
    )

  $noticeMsg: (notice) ->
    return JSON.stringify(
      type: 'notice'
      payload: notice
    )

  $sendDisNotice: (notice) ->
    @sendToOne notice.userId, @noticeMsg notice

  $sendNotices: (notices) ->
    for notice in notices
      @sendToOne notice.userId, @noticeMsg notice

  $sendQuizMsg: (answers, question, teacherId) ->
    for answer in answers
      @sendToOne answer.userId, @quizMsg(answer, question, teacherId)

  $sendQuizAnswerMsg: (userId, answer) ->
    @sendToOne userId, JSON.stringify {type: 'quiz_answer', payload: answer}

  $sendToGroup: (userIds, msg) ->
    for userId in userIds
      @sendToOne userId, msg


  $sendToOne: (userId, msg) ->
    unless global.socketMap[userId]?
      return logger.warn "userId: #{userId}, socket does not exists"

    global.socketMap[userId].ws.write msg
