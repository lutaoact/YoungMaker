'use strict'

CourseUtils = _u.getUtils 'course'
StatsUtils  = _u.getUtils 'stats'
Question    = _u.getModel 'question'
QuizAnswer  = _u.getModel 'quiz_answer'
User        = _u.getModel 'user'

exports.myView = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  StatsUtils.makeQuizStatsPromiseForUser user, courseId
  .then (finalStats) ->
#    logger.info finalStats
    res.send finalStats
  , (err) ->
    next err

exports.studentView = (req, res, next) ->
  courseId = req.query.courseId
  studentId = req.query.studentId
  user = req.user

  User.findByIdQ studentId
  .then (student) ->
    StatsUtils.makeQuizStatsPromiseForUser student, courseId
  .then (finalStats) ->
#    logger.info finalStats
    res.send finalStats
  , (err) ->
    next err
