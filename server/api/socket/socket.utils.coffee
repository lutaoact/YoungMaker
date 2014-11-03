BaseUtils = require('../../common/BaseUtils')
jwt = require('jsonwebtoken')

class SocketUtils extends BaseUtils
  verify: (token, cb) ->
    deferred = do Q.defer
    jwt.verify token, config.secrets.session, null, (err, user) ->
      if err then deferred.reject err else deferred.resolve user

    return deferred.promise.nodeify cb

  _buildMsg: (type, data) ->
    return JSON.stringify type: type, payload: data

  buildErrMsg: (err) ->
    util = require 'util'
    return @_buildMsg Const.MsgType.Error, {status: 401, errMsg: util.inspect err}

  sendNotices: (notices...) ->
    for notice in _.flatten notices
      @sendToOne notice.userId, Const.MsgType.Notice, notice

  sendQuizMsg: (answers, question, teacherId) ->
    for answer in answers
      @sendToOne(
        answer.userId
        Const.MsgType.Quiz
        answer:answer, question:question, teacherId: teacherId
      )

  sendQuizAnswerMsg: (userId, answer) ->
    @sendToOne userId, Const.MsgType.QuizAnswer, answer

  sendToGroup: (userIds, msg) ->
    for userId in userIds
      @sendToOne userId, msg


  sendToOne: (userId, type, payload) ->
    unless global.socketMap[userId]? then return
    logger.info "send #{type} message to userId: #{userId}"
    global.socketMap[userId].ws.write @_buildMsg(type, payload)

exports.Class = SocketUtils
exports.Instance = new SocketUtils()
