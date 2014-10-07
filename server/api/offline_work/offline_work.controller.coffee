'use strict'

OfflineWork = _u.getModel 'offline_work'
LectureUtils = _u.getUtils 'lecture'

exports.index = (req, res, next) ->
  lectureId = req.query.lectureId
  user = req.user

  (switch user.role
    when 'teacher'
      OfflineWork.find
        lectureId : lectureId
      .populate 'userId', 'name, email'
      .execQ()
    when 'student'
      OfflineWork.findQ
        lectureId : lectureId
        userId : req.user.id
    else
      Q.reject
        status : 404
        errCode : ErrCode.ForbiddenRole
        errMsg : 'role is forbidden to do this action'
  ).then (answers) ->
    res.send answers
  , next


exports.show = (req, res, next) ->
  user = req.user
  condition = _id: req.params.id
  #如果不是这两种role，则必须要相应的userId也要匹配
  unless ~(['teacher', 'admin'].indexOf user.role)
    condition.userId = user._id

  OfflineWork.findOneQ condition
  .then (work) ->
    res.send work
  , (err) ->
    res.send err

exports.create = (req, res, next) ->
  userId = req.user.id
  lectureId = req.query.lectureId

  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    body = req.body
    delete body._id

    body.userId = userId
    body.lectureId = lectureId

    HomeworkAnswer.createQ body
  .then (work) ->
    res.send 201, work
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  HomeworkAnswer.removeQ _id: req.params.id
  .then () ->
    res.send 204
  , (err) ->
    next err
