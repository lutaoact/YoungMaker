BaseUtils = require('../../common/BaseUtils').BaseUtils
Question = _u.getModel 'question'

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
