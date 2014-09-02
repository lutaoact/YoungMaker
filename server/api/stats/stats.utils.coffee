BaseUtils = require('../../common/BaseUtils').BaseUtils
Question = _u.getModel 'question'
CourseUtils = _u.getUtils 'course'

exports.StatsUtils = BaseUtils.subclass
  classname: 'StatsUtils'

  # {questionId: answerString}
  buildQAMap: (questionIds) ->
    Question.findQ {_id: {$in: questionIds}}
    .then (questions) ->
      map = _.reduce(questions, (result, question) ->
        body = question.content.body
        result[question.id] = _.reduce(body, (corrects, option, index) ->
          if option.correct is true
            corrects.push index
          return corrects
        , []).toString()
        return result
      , {})
      return map
    , (err) ->
      Q.reject err

  computeCorrectNumByQuizAnswers: (myQAMap, quizAnswers) ->
    Q.resolve _.reduce(quizAnswers, (sum, quizAnswer) ->
      if quizAnswer.result.toString() is myQAMap[quizAnswer.questionId]
        sum++
      return sum
    , 0)

  computeFinalStats: (studentsNum, middleResult) ->
    for lectureId, result of middleResult
      result.percent =
        result.correctNum * 100 // (studentsNum * result.questionsLength)

    summary = _.reduce(middleResult, (sum, result) ->
      sum.questionsLength += result.questionsLength
      sum.correctNum      += result.correctNum
      return sum
    , {questionsLength:0, correctNum: 0})
    summary.percent =
      summary.correctNum * 100 // (studentsNum * summary.questionsLength)
    middleResult.summary = summary

    Q.resolve middleResult
