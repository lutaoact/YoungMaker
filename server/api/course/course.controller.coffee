"use strict"

Course = _u.getModel "course"
Lecture = _u.getModel "lecture"
KeyPoint = _u.getModel "key_point"
ObjectId = require("mongoose").Types.ObjectId
CourseUtils = _u.getUtils 'course'
LearnProgress = _u.getModel 'learn_progress'

exports.index = (req, res, next) ->

  userId = req.user.id
  role = req.user.role
  (switch role
    when 'teacher'
      logger.info 'teacher'
      CourseUtils.getTeacherCourses userId
    when 'student'
      logger.info 'student'
      if req.query.public?
        Course.findQ public:true
      else
        CourseUtils.getStudentCourses userId
    when 'admin'
      logger.info 'admin'
      teacherId = req.query.teacherId
      CourseUtils.getTeacherCourses teacherId
  ).then (courses) ->
    res.send courses
  # use Q's fail to make sure error from last then is also caught and passed to next
  # need to change our code all over the place to adapt to this pattern
  .fail next


exports.show = (req, res, next) ->
  courseId = req.params.id
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    course.populateQ 'owners classes'
  .then (course) ->
    res.send course
  .fail next

exports.create = (req, res, next) ->
  req.body.owners = [req.user.id]
  Course.createQ req.body
  .then (course) ->
    res.json 201, course
  .fail next

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
    course.populateQ 'owners classes'
    .then (course) ->
      res.send course
  .fail next


exports.destroy = (req, res, next) ->
  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    console.log 'Found course to delete'
    Course.removeQ
      _id : course._id
  .then () ->
    res.send 204
  .fail next
