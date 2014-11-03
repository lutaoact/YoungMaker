"use strict"

Course = _u.getModel "course"
Lecture = _u.getModel "lecture"

exports.index = (req, res, next) ->
  Course.findAllQ()
  .then (result) ->
    res.send result
  .catch next
  .done()


exports.show = (req, res, next) ->
  Course.findByIdQ req.params.id
  .then (course) ->
    res.send course
  .catch next
  .done()


exports.create = (req, res, next) ->
  body = req.body
  delete body._id
  Course.createQ body
  .then (result) ->
    res.json 201, result
  .catch next
  .done()


exports.update = (req, res, next) ->
  body = req.body
  delete body._id

  Course.findByIdQ req.params.id
  .then (course) ->
    updated = _.extend course, body
    do updated.saveQ
  .then (result) ->
    res.send result[0]
  .catch next
  .done()


exports.destroy = (req, res, next) ->
  Course.removeQ _id : course._id
  .then () ->
    res.send 204
  .catch next
  .done()
