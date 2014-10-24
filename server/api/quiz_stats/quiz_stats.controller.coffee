'use strict'

StatsUtils  = _u.getUtils 'stats'
LectureUtils = _u.getUtils 'lecture'
Course = _u.getModel 'course'
User        = _u.getModel 'user'

exports.show = (req, res, next) ->
  courseId = req.query.courseId
  queryUserId = req.query.userId ? req.query.studentId
  user = req.user

  tmpResult = {}
  (if ~(['teacher', 'admin'].indexOf user.role) and queryUserId?
    User.findByIdQ queryUserId
    .then (queryUser) ->
      if user.orgId.toString() isnt queryUser.orgId.toString()
        return Q.reject
          status : 403
          errCode : ErrCode.NotSameOrg
          errMsg : 'not the same org'

      tmpResult.queryUser = queryUser
    .then () ->
      CourseUtils.getAuthedLectureById user, courseId
    .then (course) ->
      return tmpResult.queryUser if course?
  else
    Q(user)
  ).then (person) ->
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
