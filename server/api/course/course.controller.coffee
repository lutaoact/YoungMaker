#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /courses              ->  index
# * POST    /courses              ->  create
# * GET     /courses/:id          ->  show
# * PUT     /courses/:id          ->  update
# * DELETE  /courses/:id          ->  destroy
# 

"use strict"

_ = require("lodash")
Course = _u.getModel "course"
Lecture = _u.getModel "lecture"
KnowledgePoint = _u.getModel "knowledge_point"
ObjectId = require("mongoose").Types.ObjectId
CourseUtils = _u.getUtils 'course'

exports.index = (req, res) ->

  userId = req.user.id
  role = req.user.role
  switch role
    when 'teacher'
      CourseUtils.getTeacherCourses userId
      .then (courses) ->
        res.json 200, courses
      , (err) ->
        res.json 500, err

    when 'student'
      CourseUtils.getStudentCourses userId
      .then (courses) ->
        res.json 200, courses
      , (err) ->
        res.json 500, err


exports.show = (req, res) ->
  Course.findById(req.params.id).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    res.json course


exports.create = (req, res) ->
  req.body.owners = [req.user.id]
  Course.create req.body, (err, course) ->
    return handleError(res, err)  if err
    res.json 201, course

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  #classes can only be added by creating class_progress.
  delete req.body.classes  if req.body.classes
  Course.findOne
    _id: req.params.id
    owners:
      $in: [req.user.id]
  , (err, course) ->
    return handleError(err)  if err
    return res.send(404)  unless course
    updated = _.extend(course, req.body)
    updated.markModified "lectureAssembly"
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, course


exports.destroy = (req, res) ->
  Course.findById req.params.id, (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    course.remove (err) ->
      return handleError(res, err)  if err
      res.send 204





handleError = (res, err) ->
  res.send 500, err
