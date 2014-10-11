Question = _u.getModel 'question'

class QuestionUtils
  getQAMap: (questions) ->
    return _.reduce(questions, (result, question) =>
      if question.type is Const.QuestionType.Choice
        result[question._id] = @getAnswerArrayFromQuestion question
      return result
    , {})

  getAnswerArrayFromQuestion: (question) ->
    return _.reduce(question.choices, (corrects, option, index) ->
      if option.correct is true
        corrects.push index
      return corrects
    , [])


exports.QuestionUtils = QuestionUtils
