require '../common/init'

RecommendUtils = _u.getUtils 'recommend'
StatsUtils = _u.getUtils 'stats'
StatsUtils.computeUserAnswerStats '5438f983f26f910320e27f3b'
.then (stats) ->
  kpList = RecommendUtils.convertUserAnswerStats2kpList stats
  RecommendUtils.recommendQuestions kpList
.then (questionIds) ->
  console.log questionIds
, (err) ->
  console.log err
