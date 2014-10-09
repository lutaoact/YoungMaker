'use strict'

DisTopic = _u.getModel 'dis_topic'
DisReply = _u.getModel 'dis_reply'
CourseUtils = _u.getUtils 'course'
DisUtils = _u.getUtils 'dis'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'

exports.index = (req, res, next) ->
  user = req.user
  disTopicId = req.query.disTopicId
  from = ~~req.query.from #from参数转为整数

  DisTopic.findByIdQ disTopicId
  .then (disTopic) ->
    CourseUtils.getAuthedCourseById user, disTopic.courseId
  .then (course) ->
    DisReply.find
      disTopicId: disTopicId
    .populate 'postBy', '_id name avatar'
    .sort created: -1
    .limit Const.PageSize.DisReply
    .skip from
    .execQ()
  .then (disReplies) ->
    res.send disReplies
  , (err) ->
    next err

exports.create = (req, res, next) ->
  user     = req.user
  disTopicId = req.query.disTopicId
  body     = req.body
  delete body._id

  tmpResult = {}
  DisTopic.findByIdQ disTopicId
  .then (disTopic) ->
    tmpResult.disTopic = disTopic
    CourseUtils.getAuthedCourseById user, disTopic.courseId
  .then (course) ->
    #don't post voteUpUsers field, it's illegal, I will override it
    #新的disReply这个字段值应该为空，所以强制赋为空数组
    body.voteUpUsers = []
    body.postBy      = user._id
    body.disTopicId  = disTopicId

    DisReply.createQ body
  .then (disReply) ->
    tmpResult.disReply = disReply
    tmpResult.disTopic.updateQ {$inc: {repliesNum: 1}}
  .then (disTopic) ->
    tmpResult.disReply.populateQ 'postBy', 'name avatar'
  .then (disReply) ->
    tmpResult.disReply = disReply
    NoticeUtils.addTopicCommentNotice(
      tmpResult.disTopic.postBy
      user._id
      disReply._id
    )
  .then (notice) ->
    SocketUtils.sendNotices notice
  .then () ->
    res.send 201, tmpResult.disReply
  , (err) ->
    next err

exports.update = (req, res, next) ->
  user = req.user
  updateBody = {}
  updateBody.content   = req.body.content   if req.body.content?

  DisReply.findOneQ
    _id : req.params.id
    postBy : req.user.id
  .then (disReply) ->
    updated = _.extend disReply, updateBody
    do updated.saveQ
  .then (result) ->
    newValue = result[0]
    newValue.populateQ 'postBy', 'name avatar'
  .then (newDisReply) ->
    res.send newDisReply
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  tmpResult = {}
  DisReply.findOneQ
    _id: req.params.id
    postBy : req.user.id
  .then (disReply) ->
    tmpResult.disReply = disReply
    DisTopic.updateQ {_id: disReply.disTopicId}, {$inc: {repliesNum: -1}}
  .then () ->
    do tmpResult.disReply.removeQ
  .then () ->
    res.send 204
  , (err) ->
    next err

exports.vote = (req, res, next) ->
  disReplyId = req.params.id
  userId = req.user._id

  tmpResult = {}
  DisUtils.vote DisReply, disReplyId, userId
  .then (dis) ->
    res.send dis
  , (err) ->
    next err
