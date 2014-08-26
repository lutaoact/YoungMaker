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
KeyPoint = _u.getModel "key_point"
ObjectId = require("mongoose").Types.ObjectId
CourseUtils = _u.getUtils 'course'

exports.index = (req, res, next) ->

  userId = req.user.id
  role = req.user.role
  switch role
    when 'teacher'
      CourseUtils.getTeacherCourses userId
      .then (courses) ->
        res.send courses
      , (err) ->
        next err

    when 'student'
      CourseUtils.getStudentCourses userId
      .then (courses) ->
        res.send courses
      , (err) ->
        next err

    when 'admin'
      Course.findQ {}
      .then (courses) ->
        res.send courses
      , (err) ->
        next err


exports.show = (req, res, next) ->
  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    res.send course
  , (err) ->
    next err

exports.create = (req, res, next) ->
  req.body.owners = [req.user.id]
  Course.createQ req.body
  .then (course) ->
    res.json 201, course
  , (err) ->
    next err

exports.update = (req, res, next) ->

  # keep old id
  delete req.body._id  if req.body._id

  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    updated = _.extend course, req.body
    updated.markModified 'lectureAssembly'
    updated.markModified 'classes'
    updated.save (err) ->
      next err if err
      res.send updated
  , (err) ->
    next err


exports.destroy = (req, res, next) ->
  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    console.log 'Found course to delete'
    Course.removeQ
      _id : course._id
  .then () ->
    res.send 204
  , (err) ->
    next err
