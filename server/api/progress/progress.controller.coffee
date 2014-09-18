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
  .then (progressObject) ->
    res.send progressObject?.progress ? []
  , next
