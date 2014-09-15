"use strict"

Question = _u.getModel "question"
Classe = _u.getModel 'classe'
SocketUtils = _u.getUtils 'socket'

exports.index = (req, res, next) ->
  categoryId = req.query.categoryId
  user = req.user

  conditions = orgId: user.orgId
  conditions.categoryId = req.query.categoryId if req.query.categoryId?

  if req.query.keyPointIds?
    conditions.keyPoints = {$in: JSON.parse req.query.keyPointIds}
  if req.query.keyword?
    keyword = req.query.keyword
    regex = new RegExp(keyword.replace /[{}()^$|.\[\]*?+]/g, '\\$&')
    conditions.$or = [
      'content.title': regex
    ,
      'content.body.desc': regex
    ]

  logger.info conditions

  Question.findQ conditions
  .then (questions) ->
    res.send questions
  , (err) ->
    next err

exports.show = (req, res, next) ->
  user = req.user
  questionId = req.params.id
  Question.findOneQ
    _id: questionId
    orgId: user.orgId
  .then (question) ->
    res.send question
  , (err) ->
    console.log err
    next err

exports.create = (req, res, next) ->
  body = req.body
  body.orgId = req.user.orgId
  delete body._id

  Question.createQ body
  .then (question) ->
    res.json 201, question
  , (err) ->
    next err

exports.update = (req, res, next) ->
  questionId = req.params.id
  body = req.body
  delete body._id
  delete body.orgId

  Question.findByIdQ questionId
  .then (question) ->
    updated = _.extend question, body
#    updated.markModified 'content'
    do updated.saveQ
  .then (result) ->
    newClasse = result[0]
    res.send newClasse
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  questionId = req.params.id
  Question.removeQ
    _id: questionId
  .then () ->
    res.send 204
  , (err) ->
    next err

exports.pubQuiz = (req, res, next) ->
  questionId = req.query.questionId
  classId = req.query.classId
  tmpResult = {}
  Question.findByIdQ questionId
  .then (question) ->
    tmpResult.question = question
    Classe.findByIdQ classId
  .then (classe) ->
    SocketUtils.sendToGroup(
      SocketUtils.quizMsg tmpResult.question
      classe.students
    )

    res.send 200
  , next
