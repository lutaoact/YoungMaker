"use strict"

Question = _u.getModel "question"
Classe = _u.getModel 'classe'
QuizAnswer = _u.getModel 'quiz_answer'
SocketUtils = _u.getUtils 'socket'

################################################################
## 题库检索条件：
## 1. user.orgId && deleteFlag非true
## 2. 类别categoryId
## 3. 知识点列表keyPointIds
## 4. 关键字keyword，题目的标题和描述是否包含相应关键字
################################################################
exports.index = (req, res, next) ->
  user = req.user

  conditions = orgId: user.orgId, deleteFlag: $ne: true
  conditions.categoryId = req.query.categoryId if req.query.categoryId?

  if req.query.keyPointIds?
    keyPointIds = JSON.parse req.query.keyPointIds
    conditions.keyPoints = {$in: keyPointIds} if keyPointIds.length > 0
  if req.query.keyword?
    keyword = req.query.keyword
    #对可能出现的正则元字符进行转义
    regex = new RegExp(keyword.replace /[{}()^$|.\[\]*?+]/g, '\\$&')
    conditions.$or = [
      'body': regex
    ,
      'choices.text': regex
    ]

  logger.info conditions

  from = ~~req.query.from #from参数转为整数
  limit = ~~(req.query.limit ? Const.PageSize.Question)

  countPromise = Question.countQ conditions
  queryPromise = Question.find conditions
                .sort 'created'
                .skip from
                .limit limit
                .populate 'keyPoints', 'name'
                .execQ()

  Q.all [countPromise, queryPromise]
  .then (data)->
    res.send
      totalNum: data[0]
      questions: data[1]
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

#找出指定班级中的所有学生，查看他们的quiz_answer记录，若没有，则新增
#然后将question和answer通过socket发送给每一个学生
#TODO: 这是一个http请求，只要在web端登录，就可以推送问题
#但socket只留给最近登录的那个终端，如果需要抢回socket，刷新当前页面即可
exports.pubQuiz = (req, res, next) ->
  user = req.user
  {questionId, classId, lectureId} = req.body

  tmpResult = {}
  Classe.findByIdQ classId
  .then (classe) ->
    tmpResult.classe = classe
    QuizAnswer.findQ
      lectureId: lectureId
      questionId: questionId
      userId: $in: tmpResult.classe.students
  .then (quizAnswers) ->
    tmpResult.quizAnswers = quizAnswers
    tmpResult.userAnswerMap = _.indexBy quizAnswers, 'userId'

    noAnswerStudentIds = _.filter tmpResult.classe.students, (studentId) ->
      return not tmpResult.userAnswerMap[studentId]?

    QuizAnswer.createNewAnswers noAnswerStudentIds, lectureId, questionId
  .then (newAnswers) ->
    return tmpResult.quizAnswers.concat newAnswers
  .then (allAnswers) ->
    tmpResult.allAnswers = allAnswers
    Question.findById questionId
      .populate 'keyPoints', 'name'
      .execQ()
  .then (question) ->
    tmpResult.question = question
    SocketUtils.sendQuizMsg(
      tmpResult.allAnswers
      tmpResult.question
      user._id
    )
  .then ->
    res.send tmpResult.allAnswers
  , next

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  Question.updateQ
    _id: $in: ids
  ,
    deleteFlag: true
  ,
    multi: true
  .then () ->
    res.send 204
  , next
