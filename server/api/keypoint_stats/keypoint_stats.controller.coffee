'use strict'

StatsUtils = _u.getUtils 'stats'
User       = _u.getModel 'user'

exports.show = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  (if user.role is 'teacher' and req.query.studentId?
    User.findByIdQ req.query.studentId
  else
    Q(user)
  ).then (person) ->
    StatsUtils.makeKPStatsForUser person, courseId
  .then (finalStats) ->
    res.send finalStats
  , next
