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
Course = require("./course.model")
Lecture = require("../lecture/lecture.model")
KnowledgePoint = require("../knowledge_point/knowledge_point.model")
ObjectId = require("mongoose").Types.ObjectId

exports.index = (req, res) ->
  Course.find(owners:
    $in: [req.user.id]
  ).populate("classes", "_id name orgId yearGrade").exec (err, courses) ->
    return handleError(res, err)  if err
    res.json 200, courses


exports.show = (req, res) ->
  Course.findById(req.params.id).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    res.json course


exports.showLectures = (req, res) ->
  Course.findById(req.params.id).populate("lectureAssembly", "_id name").exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    res.json course.lectureAssembly


exports.showLecture = (req, res) ->
  Lecture.findById req.params.lectureId, (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    courseId = lecture.courseId
    if req.user.role is "teacher"
      Course.findOne
        _id: courseId
        owners:
          $in: [req.user.id]
      , (err, course) ->
        return handleError(res, err)  if err
        return res.send(404)  unless course
        res.json 200, lecture

    else if req.user.role is "student"
      Course.findById(courseId).populate(
        path: "classes"
        match:
          students:
            $in: [req.user.id]
      ).exec (err, course) ->
        return handleError(res, err)  if err
        return res.send(404)  if not course or 0 is course.classes.length
        res.json 200, lecture

    else if req.user.role is "admin"
      res.json 200, lecture
    else
      res.send 404


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


#TODO: sync classProgress's lecturesStatus
exports.createLecture = (req, res) ->
  Course.findOne(
    _id: req.params.id
    owners:
      $in: [req.user.id]
  ).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    req.body.courseId = req.params.id
    Lecture.create req.body, (err, lecture) ->
      return handleError(res, err)  if err
      course.lectureAssembly.push lecture._id
      course.save (err) ->
        return handleError(err)  if err #TODO: should use transactions to rollback..
        res.json 201, lecture


exports.updateLecture = (req, res) ->
  delete req.body._id  if req.body._id
  Lecture.findById req.params.lectureId, (err, lecture) ->
    updated = undefined
    return handleError(err)  if err
    return res.send(404)  unless lecture
    Course.findOne(
      _id: lecture.courseId
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      updated = _.extend(lecture, req.body)
      updated.save (err) ->
        return handleError(err)  if err
        res.json 200, lecture


exports.destroyLecture = (req, res) ->
  Lecture.findById req.params.lectureId, (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    Course.findOne(
      _id: lecture.courseId
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      #delete from Course's lectureAssembly list
      lecture.remove (err) ->
        return handleError(res, err)  if err
        _.remove course.lectureAssembly, new ObjectId(req.params.lectureId)
        course.markModified "lectureAssembly"
        course.save (err) ->
          return handleError(res, err)  if err
          res.send 204


# insert knowledgePoint id to this Lecture; create a knowledgePoint when _id is not provided
exports.createKnowledgePoint = (req, res) ->
  updateLectureKnowledgePoints = (knowledgePoint) ->
    Lecture.findByIdAndUpdate req.params.lectureId,
      $push:
        knowledgePoints: knowledgePoint._id
    , (err, lecture) ->
      return handleError(res, err)  if err
      res.send knowledgePoint

  Course.findOne(
    _id: req.params.id
    owners:
      $in: [req.user.id]
  ).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    if req.body._id # TODO: validate this _id!
      updateLectureKnowledgePoints req.body
    else
      KnowledgePoint.create req.body, (err, knowledgePoint) ->
        return handleError(err)  if err
        updateLectureKnowledgePoints knowledgePoint


exports.showKnowledgePoints = (req, res) ->
  Lecture.findById(req.params.lectureId).populate("knowledgePoints").exec (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    res.json lecture.knowledgePoints


handleError = (res, err) ->
  res.send 500, err
