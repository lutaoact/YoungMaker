"use strict"

Activity = _u.getModel 'activity'
LearnProgress = _u.getModel 'learn_progress'
TeachProgress = _u.getModel 'teach_progress'

exports.create = (req, res, next) ->
  user = req.user
  body = req.body
  delete body._id

  tmpRes = {}

  body.userId = user._id
  Activity.createQ body
  .then (activity) ->
    tmpRes.activity = activity
    switch activity.eventType
      when Const.Student.ViewLecture
        LearnProgress.upsertProgress(
          activity.userId
          activity.data.courseId
          activity.data.lectureId
        )
      when Const.Teacher.ViewLecture
        TeachProgress.upsertProgress(
          activity.userId
          activity.data.classeId
          activity.data.courseId
          activity.data.lectureId
        )
      else
        Q.reject
          status : 404
          errCode : ErrCode.NoMatchedEventType
          errMsg : 'there is no matched event type'
  .then () ->
    res.send tmpRes.activity
  , next
