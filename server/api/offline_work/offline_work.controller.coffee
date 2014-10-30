'use strict'

OfflineWork = _u.getModel 'offline_work'
LectureUtils = _u.getUtils 'lecture'

exports.index = (req, res, next) ->
  lectureId = req.query.lectureId
  user = req.user

  (switch user.role
    when 'teacher'
      OfflineWork.findQ
        lectureId : lectureId
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

    OfflineWork.createQ body
  .then (work) ->
    res.send 201, work
  , next

exports.update = (req, res, next) ->
  body = req.body

  data =
    files: body.files,
    desc: body.desc,
    submitted: body.submitted

  OfflineWork.findOneQ
    _id : req.params.id
  .then (offlineWork) ->
    if offlineWork.submitted is true
      Q.reject
        status : 403
        errCode : ErrCode.ForbiddenRole
        errMsg : '学生不能修改已提交的作业'

    updated = _.extend offlineWork, data
    do updated.saveQ
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , next

exports.giveScore = (req, res, next) ->
  offlineWorkId = req.params.id
  user = req.user

  OfflineWork.findByIdQ offlineWorkId
  .then (offlineWork) ->
    if offlineWork.checked is true
      return Q.reject(
        status : 403
        errCode : ErrCode.GiveScore
        errMsg : '作业已批改，操作不可重复进行'
      )

    #更新老师批改作业的相应字段
    offlineWork.teacherId = user._id
    offlineWork.score    = req.body.score
    offlineWork.feedback = req.body.feedback
    offlineWork.checked = true

    do offlineWork.saveQ
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , next


exports.destroy = (req, res, next) ->
  OfflineWork.removeQ _id: req.params.id
  .then () ->
    res.send 204
  , next
