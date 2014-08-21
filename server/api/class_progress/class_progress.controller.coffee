
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /classProgress              ->  index
# * POST    /classProgress              ->  create
# * GET     /classProgress/:id          ->  show
# * PUT     /classProgress/:id          ->  update
# * DELETE  /classProgress/:id          ->  destroy
# 

"use strict"
_ = require("lodash")

ClassProgress = _u.getModel "class_progress"
Course = _u.getModel "course"

exports.index = (req, res) ->
  ClassProgress.find (err, classProgresses) ->
    return handleError(res, err)  if err
    res.json 200, classProgresses


exports.show = (req, res) ->
  ClassProgress.findById req.params.id, (err, classProgress) ->
    return handleError(res, err)  if err
    return res.send(404)  unless classProgress
    res.json classProgress


# TODO: need to check if classId is in Course.
exports.create = (req, res) ->
  req.body.userId = req.user.id
  delete req.body.lecturesStatus  if req.body.lecturesStatus
  Course.findById req.body.courseId, (err, course) ->
    req.body.lecturesStatus = []

    req.body.lecturesStatus.push {'lectureId': lecture, 'isFinished': false} for lecture in course.lectureAssembly

    ClassProgress.create req.body, (err, classProgress) ->
      return handleError(res, err)  if err
      res.json 201, classProgress


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  ClassProgress.findById req.params.id, (err, classProgress) ->
    updated = undefined
    return handleError(err)  if err
    return res.send(404)  unless classProgress
    updated = _.extend(classProgress, req.body)
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, classProgress


exports.destroy = (req, res) ->
  ClassProgress.findById req.params.id, (err, classProgress) ->
    return handleError(res, err)  if err
    return res.send(404)  unless classProgress
    classProgress.remove (err) ->
      return handleError(res, err)  if err
      res.send 204


handleError = (res, err) ->
  res.send 500, err
