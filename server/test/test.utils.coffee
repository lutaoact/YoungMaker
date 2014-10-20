require '../common/init'

Recommend = _u.getUtils 'recommend'
Recommend.recommendQuestions [
  kpId: '543905e08bfa93952219bcf7', level: 35
,
  kpId: '543906828bfa93952219bd18', level: 64
,
  kpId: '543906828bfa93952219bd18', level: 74
]
.then (questionIds) ->
  console.log questionIds
, (err) ->
  console.log err
