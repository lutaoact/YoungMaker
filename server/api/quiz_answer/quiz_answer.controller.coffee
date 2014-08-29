###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /quiz_answers             ->  index
 * POST    /quiz_answers             ->  create
 * GET     /quiz_answers/:id          ->  show
 * DELETE  /quiz_answers/:id          ->  destroy
 ###

'use strict'

QuizAnswer = _u.getModel 'quiz_answer'
LectureUtils = _u.getUtils 'lecture'

exports.index = (req, res, next) ->
  lectureId = req.query.lectureId
  role = req.user.role

  # check if user has access to the given lecture
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
  switch role
    when 'teacher'
      questionId = req.query.questionId # only teacher needs question ID
      QuizAnswer.find
        lectureId : lectureId
        questionId : questionId
      .populate 'userId', '_id, name, email'
      .execQ()
      .then (answers) ->
        res.send answers
      , (err) ->
        next err
    when 'student'
      QuizAnswer.findQ
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
      QuizAnswer.findByIdQ
        _id : answerId
      .then (answer) ->
        res.send answer
      , (err) ->
        next err
    when 'student'
      QuizAnswer.findOneQ
        _id : answerId # to make sure user has access to this answer
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
    QuizAnswer.createQ body
    .then (answer) ->
      res.send 201, answer
    , (err) ->
      next err

exports.destroy = (req, res, next) ->
  QuizAnswer.removeQ
    _id: req.params.id
  .then () ->
    res.send 204
  , (err) ->
    next err

exports.deleteByLectureId = (req, res, next) ->
  lectureId = req.query.lectureId
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    QuizAnswer.removeQ
      lectureId: req.query.lectureId
    .then () ->
      res.send 204
    , (err) ->
      next err
