'use strict'

OfflineWork = _u.getModel 'offline_work'

exports.index = (req, res, next) ->
  lectureId = req.query.lectureId
  user = req.user

  (switch user.role
    when 'teacher'
      OfflineWork.find
        lectureId : lectureId
      .populate 'userId', '_id, name, email'
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

exports.create = (req, res, next) ->

exports.destroy = (req, res, next) ->
