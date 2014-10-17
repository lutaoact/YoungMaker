'use strict'

StatsUtils  = _u.getUtils 'stats'
LectureUtils = _u.getUtils 'lecture'
User        = _u.getModel 'user'
Question    = _u.getModel 'question'
HomeworkAnswer = _u.getModel 'homework_answer'

buildQuizResult = (lecture, qIds) ->
  Q.all _.map qIds, (qId) ->
    question = null
    Question.findByIdQ qId
    .then (q) ->
      question = q
      StatsUtils.getQuizStats lecture._id, qId
    .then (stats) ->
      return {
        question: question
        stats: stats
      }
  
buildHWResult = (lectureId) ->
  HomeworkAnswer.findQ
    lectureId : lectureId
  .then (hwas) ->
    # hwResult object to save middle result like this:
    # key : questionId
    # value : Array of answers for this question. For example
    # [[0,1], [1], [0], [1,2]]
    hwResult = _.reduce hwas, (tmpResult, hwa) ->
      results = hwa.result
      _.forEach results, (result) ->
        qId = result.questionId
        if tmpResult.hasOwnProperty qId
          tmpResult[qId].push result.answer
        else
          tmpResult[qId] = [result.answer]
      return tmpResult
    , {}
    
    Q.all _.map hwResult , (answers, qId) ->
      stats = _.countBy (_.flatten answers) , (answer) -> answer
      Question.findByIdQ qId
      .then (question) ->
        return {
          question : question
          stats : stats
        }
  
  
exports.questionStats = (req, res, next) ->
  lectureId = req.params.id
  logger.info "Get stats for lecture #{lectureId}"
  
  user = req.user
  finalResult = []
  LectureUtils.getAuthedLectureById user, lectureId
  .then (lecture) ->
    quizIds = lecture.quizzes
    buildQuizResult lecture, quizIds
  .then (quizStats) ->
    finalResult = finalResult.concat quizStats
    buildHWResult lectureId
  .then (hwStats) ->
    finalResult = finalResult.concat hwStats
    res.send 200, finalResult
  .fail next
      
