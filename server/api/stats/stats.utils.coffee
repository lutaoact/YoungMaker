BaseUtils = require('../../common/BaseUtils').BaseUtils
Question = _u.getModel 'question'
CourseUtils = _u.getUtils 'course'
QuizAnswer = _u.getModel 'quiz_answer'
HomeworkAnswer = _u.getModel 'homework_answer'

exports.StatsUtils = BaseUtils.subclass
  classname: 'StatsUtils'

  makeKPStatsForUser: (user, courseId) ->
    tmpResult = {}
#    logger.info tmpResult
    @getStatsStudentsNum user, courseId
    .then (studentsNum) ->
      tmpResult.studentsNum = studentsNum
#      logger.info tmpResult
      CourseUtils.getAuthedCourseById user, courseId
    .then (course) ->
#      logger.info course
      course.populateQ 'lectureAssembly', 'name quizzes homeworks'
    .then (course) =>
      tmpResult.course = course
      promiseArray = for lecture in course.lectureAssembly
        @makeKPStatsForSpecifiedLecture lecture

      Q.all promiseArray
    .then (statsArray) =>
#      logger.info statsArray
#      logger.info tmpResult.course.lectureAssembly
      return tmpResult
    , (err) ->
      Q.reject err


  makeKPStatsForSpecifiedLecture: (lecture) ->
    questionIds = _u.union lecture.quizzes, lecture.homeworks
#    logger.info "union result"
#    logger.info questionIds
    lectureId = lecture.id

    resolveResult =
      lectureId: lectureId
      name: lecture.name
      stats: {}

    tmpResult = {}
    Question.findQ {_id: {$in: questionIds}}
    .then (questions) =>
      tmpResult.questions = questions
      return @buildQKAsByQuestions questions
    .then (myQKAs) =>
#      logger.info "myQKAs"
#      logger.info myQKAs

#      tmpResult.myQKAs = myQKAs
#      tmpResult.myKPsCount = @getKPsCountFromQKAs myQKAs
      tmpResult.myQAMap = _.indexBy myQKAs, 'questionId'

      resolveResult.stats = @transformKPsCountToMap @getKPsCountFromQKAs myQKAs
      do Q.resolve
    .then () ->
      HomeworkAnswer.getByLectureId lectureId
    .then (homeworkAnswers) ->
      tmpResult.homeworkAnswers = homeworkAnswers
      QuizAnswer.getByLectureIdAndQuestionIds lectureId, questionIds
    .then (quizAnswers) ->
      tmpResult.quizAnswers = quizAnswers

      logger.info resolveResult
      logger.info tmpResult
      return tmpResult

  transformKPsCountToMap: (myKPsCount) ->
    return _.indexBy (for kpId, count of myKPsCount
      kpId: kpId
      total: count
      correctNum: 0
      percent: 0
    ), 'kpId'
#    return _.reduce(myKPsCount, (result, count, kpId) ->
#      result.kpId = count
#      return result
#    , {})


  #KPs: [keyPointId], QKAs [{questionId, keyPointIds, answer}]
  getKPsCountFromQKAs: (myQKAs) ->
    allKPs = _.flatten(_.pluck myQKAs, 'kps')
    return _.countBy allKPs, (ele) ->
      return ele


  #QKA: questionId keyPointIds answer
  buildQKAsByQuestions: (questions) ->
    return (for question in questions
      questionId: question.id
      kps: question.keyPoints
      answer: @getAnswerStringFromQuestion question
    )


  getAnswerStringFromQuestion: (question) ->
    return _.reduce(question.content.body, (corrects, option, index) ->
      if option.correct is true
        corrects.push index
      return corrects
    , []).toString()


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
