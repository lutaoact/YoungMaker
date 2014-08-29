'use strict'

DisTopic = _u.getModel 'dis_topic'
CourseUtils = _u.getUtils 'course'

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
    disTopic.postBy = user #populate postBy field
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
    newValue = result[0]
    res.send newValue
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

  DisTopic.findByIdQ disTopicId
  .then (disTopic) ->
    if disTopic.voteUpUsers.indexOf(userId) > -1
      disTopic.voteUpUsers.pull userId
    else
      disTopic.voteUpUsers.addToSet userId

    do disTopic.saveQ
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , (err) ->
    next err
