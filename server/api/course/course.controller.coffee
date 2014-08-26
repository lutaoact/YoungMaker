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

exports.index = (req, res, next) ->

  userId = req.user.id
  console.dir req.user
  role = req.user.role
  switch role
    when 'teacher'
      console.log 'user is teacher...'
      CourseUtils.getTeacherCourses userId
      .then (courses) ->
        res.json 200, courses || []
      , (err) ->
        next err

    when 'student'
      CourseUtils.getStudentCourses userId
      .then (courses) ->
        res.json 200, courses || []
      , (err) ->
        next err

    when 'admin'
      Course.findQ {}
      .then (courses) ->
        res.json 200, courses || []
      , (err) ->
        next err


exports.show = (req, res, next) ->
  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    res.json 200, course || {}
  , (err) ->
    next err

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
  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    course.removeQ {}
  .then ->
    res.send 204
  , (err) ->
    next err
