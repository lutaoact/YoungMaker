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
        Schedule.find course: $in: _.pluck courses, '_id'
        .populate 'course classe'
        .execQ()
    when 'student'
      tmpRes = {}
      Classe.findOneQ students: user._id
      .then (classe) ->
        tmpRes.classe = classe
        Course.findQ classes: classe._id
      .then (courses) ->
        Schedule.find
          course: $in: _.pluck courses, '_id'
          classe: tmpRes.classe._id
        .populate 'course classe'
        .execQ()
  ).then (schedules) ->
    res.send schedules
  , next

exports.create = (req, res, next) ->
  body = req.body
  delete body._id

  Schedule.createQ body
  .then (schedule) ->
    res.send schedule
  , next

exports.upsert = (req, res, next) ->
  body = req.body
  delete body._id

  conditon =
    course: body.course
    classe: body.classe

  Schedule.updateQ conditon, {
      start: body.start
      end: body.end
      until: body.until
  }, {upsert: true}
  .then () ->
    res.send body
  , next
