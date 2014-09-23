'use strict'

User = _u.getModel "user"
Classe = _u.getModel 'classe'
QuizAnswer = _u.getModel 'quiz_answer'

{StudentId, ClasseId, UserNum} = Const.Demo

exports.getUser = (req, res, next) ->
  logger.info "global.demoUserCount: #{global.demoUserCount}"
  currentId = _s.sprintf StudentId, global.demoUserCount++ % UserNum
  tmpResult = {}
  User.findByIdQ currentId
  .then (user) ->
    tmpResult.user = user
    Classe.updateQ {_id: ClasseId}, {$addToSet: {students: user._id}}
  .then () ->
    res.send tmpResult.user
  , next


exports.clear = (req, res, next) ->
  QuizAnswer.removeQ
    $and: [
      userId: $gte: _s.sprintf StudentId, 0
    ,
      userId: $lte: _s.sprintf StudentId, UserNum - 1
    ]
  .then () ->
    Classe.updateQ {_id: ClasseId}, {students: []}
  .then () ->
    global.demoUserCount = 0
    res.send 200
  , next
