'use strict'

DisTopic = _u.getModel 'dis_topic'
DisReply = _u.getModel 'dis_reply'
CourseUtils = _u.getUtils 'course'
DisUtils = _u.getUtils 'dis'

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

  DisTopic.findByIdQ disTopicId
  .then (disTopic) ->
    CourseUtils.getAuthedCourseById user, disTopic.courseId
  .then (course) ->
    #don't post voteUpUsers field, it's illegal, I will override it
    #新的disReply这个字段值应该为空，所以强制赋为空数组
    body.voteUpUsers = []
    body.postBy      = user._id
    body.disTopicId  = disTopicId

    DisReply.createQ body
  .then (disReply) ->
    disReply.postBy = user #populate postBy field
    res.send 201, disReply
  , (err) ->
    next err

exports.update = (req, res, next) ->
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
    res.send newValue
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  DisReply.removeQ
    _id: req.params.id
    postBy : req.user.id
  .then () ->
    res.send 204
  , (err) ->
    next err

exports.vote = (req, res, next) ->
  disReplyId = req.params.id
  userId = req.user._id

  DisUtils.vote DisReply, disReplyId, userId
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , (err) ->
    next err
