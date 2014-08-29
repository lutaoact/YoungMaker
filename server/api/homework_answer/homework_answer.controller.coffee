###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /homework_answers              ->  index
 * POST    /discussions                          ->  create
 * GET     /discussions/:id          ->  show
 * PUT     /discussions/:id          ->  update
 * DELETE  /discussions/:id          ->  destroy
 ###

'use strict'

HomeworkAnswer = _u.getModel 'homework_answer'
LectureUtils = _u.getUtils 'lecture'

exports.index = (req, res, next) ->
  lectureId = req.query.lectureId
  role = req.user.role

  # check if user has access to the given lecture
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
  switch role
    when 'teacher'
      HomeworkAnswer.find
        lectureId : lectureId
      .populate 'userId', '_id, name, email'
      .execQ()
      .then (answers) ->
        res.send answers
      , (err) ->
        next err
    when 'student'
      HomeworkAnswer.findQ
        lectureId : lectureId
        userId : req.user.id
      .then (answers) ->
        res.send answers
      , (err) ->
        next err
    else
      res.send 404


exports.show = (req, res, next) ->
  answerId = req.params.id
  role = req.user.role
  switch role
    when 'teacher', 'admin'
      HomeworkAnswer.findByIdQ
        _id : answerId
      .then (answer) ->
        res.send answer
      , (err) ->
        next err
    when 'student'
      HomeworkAnswer.findOneQ
        _id : answerId
        userId : req.user.id
      .then (answer) ->
        res.send answer
      , (err) ->
        next err
    else
      res.send 404

exports.create = (req, res, next) ->
  userId = req.user.id
  lectureId = req.query.lectureId

  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->

    body = req.body
    delete body._id

    body.userId = userId
    body.lectureId = lectureId
    HomeworkAnswer.createQ body
    .then (answer) ->
      res.send 201, answer
    , (err) ->
      next err

exports.destroy = (req, res, next) ->
  HomeworkAnswer.removeQ
    _id: req.params.id
  .then () ->
    res.send 204
  , (err) ->
    next err

exports.deleteByLectureId = (req, res, next) ->
  lectureId = req.query.lectureId
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    HomeworkAnswer.removeQ
      lectureId: req.query.lectureId
    .then () ->
      res.send 204
    , (err) ->
      next err
