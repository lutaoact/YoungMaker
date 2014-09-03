BaseUtils = require('../../common/BaseUtils').BaseUtils
Question = _u.getModel 'question'
CourseUtils = _u.getUtils 'course'
QuizAnswer = _u.getModel 'quiz_answer'

exports.StatsUtils = BaseUtils.subclass
  classname: 'StatsUtils'

  makeRealTimeStats: (lectureId, questionId) ->
    QuizAnswer.findQ
      lectureId: lectureId
      questionId: questionId
    .then (quizAnswers) ->
      results = _.pluck quizAnswers, 'result'
      return _.countBy(_.flatten(results), (ele) ->
        return ele
      )
    , (err) ->
      Q.reject err


  makeQuizStatsPromiseForSpecifiedLecture: (lecture) ->
    questionIds = lecture.quizzes

    resolveResult =
      lectureId: lecture.id
      name: lecture.name
      questionsLength: questionIds.length
      correctNum: 0

    tmpResult = {}

    @buildQAMap questionIds
    .then (myQAMap) =>
#      logger.info "myQAMap"
#      logger.info myQAMap
      tmpResult.myQAMap = myQAMap
      QuizAnswer.findQ
        questionId:
          $in: questionIds
        lectureId: lecture._id
    .then (quizAnswers) =>
#      logger.info "quizAnswers:"
#      logger.info quizAnswers
      tmpResult.quizAnswers = quizAnswers
      @computeCorrectNumByQuizAnswers(
        tmpResult.myQAMap, tmpResult.quizAnswers
      )
    .then (sum) =>
      resolveResult.correctNum = sum #更新correctNum
      return resolveResult


  makeQuizStatsPromiseForUser: (user, courseId) ->
    tmpResult = {}

    @getStatsStudentsNum user, courseId
    .then (studentsNum) ->
      tmpResult.studentsNum = studentsNum
      CourseUtils.getAuthedCourseById user, courseId
    .then (course) ->
      course.populateQ 'lectureAssembly', 'name quizzes'
    .then (course) =>
      promiseArray = for lecture in course.lectureAssembly
        @makeQuizStatsPromiseForSpecifiedLecture lecture

      Q.all promiseArray
    .then (statsArray) =>
#      logger.info statsArray
#      logger.info _.indexBy(statsArray, 'lectureId')

      @computeFinalStats(
        tmpResult.studentsNum
        _.indexBy statsArray, 'lectureId'
      )


  getStatsStudentsNum: (user, courseId) ->
    switch user.role
      when 'teacher' then return CourseUtils.getStudentsNum user, courseId
      when 'student' then return Q(1) #学生只统计他自己的数值


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


  computeFinalStats: (studentsNum, statsMap) ->
#    logger.info "studentsNum: #{studentsNum}"
    for lectureId, result of statsMap
      result.percent =
        result.correctNum * 100 // (studentsNum * result.questionsLength)

    summary = _.reduce(statsMap, (sum, result) ->
      sum.questionsLength += result.questionsLength
      sum.correctNum      += result.correctNum
      return sum
    , {questionsLength:0, correctNum: 0})
    summary.percent =
      summary.correctNum * 100 // (studentsNum * summary.questionsLength)
    statsMap.summary = summary

    Q.resolve statsMap
