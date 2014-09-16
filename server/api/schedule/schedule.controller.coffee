"use strict"

Schedule = _u.getModel 'schedule'
Course = _u.getModel 'course'
Classe = _u.getModel 'classe'

exports.index = (req, res, next) ->
  user = req.user
  (switch user.role
    when 'teacher'
      Course.findQ owners: user._id
      .then (courses) ->
        Schedule.find courseId: $in: _.pluck courses, '_id'
        .populate 'courseId classeId'
        .execQ()
    when 'student'
      tmpRes = {}
      Classe.findOneQ students: user._id
      .then (classe) ->
        tmpRes.classe = classe
        Course.findQ classes: classe._id
      .then (courses) ->
        Schedule.find
          courseId: $in: _.pluck courses, '_id'
          classeId: tmpRes.classe._id
        .populate 'courseId classeId'
        .execQ()
  ).then (schedules) ->
    res.send schedules
  , next
