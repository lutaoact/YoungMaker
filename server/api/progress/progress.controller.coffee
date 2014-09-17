"use strict"

LearnProgress = _u.getModel 'learn_progress'
TeachProgress = _u.getModel 'teach_progress'

exports.show = (req, res, next) ->
  user = req.user
  courseId = req.query.courseId

  condition =
    userId: user._id
    courseId: courseId

  (switch user.role
    when 'teacher'
      condition.classeId = req.query.classeId
      TeachProgress
    when 'student'
      LearnProgress
  ).findOneQ condition
  .then (progress) ->
    res.send progress
  , next

exports.upsert = (req, res, next) ->
  user = req.user
  body = req.body

  condition =
    userId: user._id
    courseId: body.courseId

  (switch user.role
    when 'teacher'
      condition.classeId = body.classeId
      TeachProgress
    when 'student'
      LearnProgress
  ).updateQ condition, {progress: body.progress}, upsert: true
  .then (progress) ->
    res.send progress
  , next
