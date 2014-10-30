require '../common/init'
StatsUtils = _u.getUtils 'stats'

teacher =
  role: 'teacher'
  _id: '111111111111111111111102'
  id: '111111111111111111111102'

courseId = '666666666666666666666600'

StatsUtils.makeKPStatsForUser teacher, courseId
.then (tmpResult) ->
  console.log tmpResult
, (err) ->
  console.log err
