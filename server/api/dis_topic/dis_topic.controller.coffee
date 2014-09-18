'use strict'

DisTopic = _u.getModel 'dis_topic'
CourseUtils = _u.getUtils 'course'
DisUtils = _u.getUtils 'dis'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'

exports.index = (req, res, next) ->
  user = req.user
  courseId = req.query.courseId
  from = ~~req.query.from #from参数转为整数

  logger.info user

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    DisTopic.find
      courseId: course._id
    .populate 'postBy', '_id name avatar'
    .sort created: -1
    .limit Const.PageSize.DisTopic
    .skip from
    .execQ()
  .then (disTopics) ->
    res.send disTopics
  , (err) ->
    next err

exports.show = (req, res, next) ->
  DisTopic.findById req.params.id
  .populate 'postBy', '_id name avatar'
  .execQ()
  .then (disTopic) ->
    res.send disTopic
  , (err) ->
    next err

exports.create = (req, res, next) ->
  user     = req.user
  courseId = req.query.courseId
  body     = req.body
  delete body._id

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    #don't post voteUpUsers field, it's illegal, I will override it
    #新记录的voteUpUsers值应该为空数组，所以强制赋值
    body.voteUpUsers = []
    body.postBy      = user._id
    body.courseId    = courseId

    DisTopic.createQ body
  .then (disTopic) ->
    disTopic.populateQ 'postBy', '_id name avatar'
  .then (disTopic) ->
    logger.info disTopic
    res.send 201, disTopic
  , (err) ->
    next err

exports.update = (req, res, next) ->
  updateBody = {}
  updateBody.title     = req.body.title     if req.body.title?
  updateBody.content   = req.body.content   if req.body.content?
  updateBody.lectureId = req.body.lectureId if req.body.lectureId?

  DisTopic.findOneQ
    _id : req.params.id
    postBy : req.user.id
  .then (disTopic) ->
    updated = _.extend disTopic, updateBody
    do updated.saveQ
  .then (result) ->
    logger.info result
    newValue = result[0]
    newValue.populateQ 'postBy', '_id name avatar'
  .then (newDisTopic) ->
    res.send newDisTopic
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  DisTopic.removeQ
    _id: req.params.id
    postBy : req.user.id
  .then () ->
    res.send 204
  , (err) ->
    next err

exports.vote = (req, res, next) ->
  disTopicId = req.params.id
  userId = req.user._id

  tmpResult = {}
  DisUtils.vote DisTopic, disTopicId, userId
  .then (result) ->
    tmpResult.newDis = result[0]
    NoticeUtils.addTopicVoteUpNotice(
      tmpResult.newDis.postBy
      userId
      tmpResult.newDis._id
    )
  .then (notice) ->
    SocketUtils.sendDisNotice notice
  .then () ->
    res.send tmpResult.newDis
  , (err) ->
    next err
