'use strict'

StatsUtils = _u.getUtils 'stats'

exports.myView = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  StatsUtils.makeKPStatsForUser user, courseId
  .then (result) ->
    res.send result
  , (err) ->
    next err

exports.studentView = (req, res, next) ->
  return 1
