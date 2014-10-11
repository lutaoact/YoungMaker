'use strict'
random = new (require('../../common/mt').MersenneTwister)()

class AnswerUtils
  buildTestQuizAnswers: (userIds, lecture, myQAMap) ->
    result = []
    lectureId = lecture._id
    quizzes   = lecture.quizzes

    for userId in userIds
      for questionId in quizzes
        answer = if random.nextInt(10) < 8 then myQAMap[questionId] else []
        result.push
          lectureId: lectureId
          questionId: questionId
          userId: userId
          result: answer

    return result

  buildTestHomeworkAnswers: (userIds, lecture, myQAMap) ->
    result = []
    lectureId = lecture._id
    homeworks   = lecture.homeworks

    if homeworks.length is 0 then return result

    for userId in userIds
      oneUserAnswers = for questionId in homeworks
        answer = if random.nextInt(10) < 8 then myQAMap[questionId] else []
        questionId: questionId
        answer: answer

      result.push
        lectureId: lectureId
        userId: userId
        result: oneUserAnswers

    return result

exports.AnswerUtils = AnswerUtils
