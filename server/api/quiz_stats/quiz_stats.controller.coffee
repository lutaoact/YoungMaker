'use strict'

StatsUtils  = _u.getUtils 'stats'
LectureUtils = _u.getUtils 'lecture'
CourseUtils = _u.getUtils 'course'
Course = _u.getModel 'course'

exports.show = (req, res, next) ->
  courseId = req.query.courseId
  queryUserId = req.query.userId ? req.query.studentId
  user = req.user

  StatsUtils.getQueryUser user, queryUserId, courseId
  .then (person) ->
    StatsUtils.makeQuizStatsPromiseForUser person, courseId
  .then (finalStats) ->
    res.send finalStats
  , next

exports.realTimeView = (req, res, next) ->
  lectureId  = req.query.lectureId
  questionId = req.query.questionId
  user = req.user

  LectureUtils.getAuthedLectureById user, lectureId
  .then (lecture) ->
    StatsUtils.getQuizStats lectureId, questionId
  .then (result) ->
    res.send result
  , next
