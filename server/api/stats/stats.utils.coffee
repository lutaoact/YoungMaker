BaseUtils = require('../../common/BaseUtils').BaseUtils
Question = _u.getModel 'question'
CourseUtils = _u.getUtils 'course'
QuizAnswer = _u.getModel 'quiz_answer'
HomeworkAnswer = _u.getModel 'homework_answer'

exports.StatsUtils = BaseUtils.subclass
  classname: 'StatsUtils'

  makeKPStatsForUser: (user, courseId) ->
    tmpResult = {}
    @getStatsStudentsNum user, courseId
    .then (studentsNum) ->
      tmpResult.studentsNum = studentsNum
      CourseUtils.getAuthedCourseById user, courseId
    .then (course) ->
      course.populateQ 'lectureAssembly', 'name quizzes homeworks'
    .then (course) =>
      tmpResult.course = course
      promiseArray = for lecture in course.lectureAssembly
        @makeKPStatsForSpecifiedLecture lecture, user

      Q.all promiseArray
    .then (statsArray) =>
      finalKPStats = @buildFinalKPStats tmpResult.studentsNum, statsArray
      #logger.info JSON.stringify finalKPStats, null, 4
      return finalKPStats
    , (err) ->
      Q.reject err


  buildFinalKPStats: (studentsNum, statsArray) ->
    courseStats   = {}
    courseSummary = total:0, correctNum:0, percent: 0
    for lectureStat in statsArray
      summary = total:0, correctNum:0, percent: 0
      for kpId, stat of lectureStat.stats
        stat.percent = @computePercent studentsNum, stat

        courseStats[kpId] ?= kpId: kpId, total: 0, correctNum: 0, percent: 0
        courseStats[kpId].total      += stat.total
        courseStats[kpId].correctNum += stat.correctNum

        summary.total      += stat.total
        summary.correctNum += stat.correctNum

      summary.percent = @computePercent studentsNum, summary
      lectureStat.summary = summary

      courseSummary.total      += summary.total
      courseSummary.correctNum += summary.correctNum

    for kpId, stat of courseStats
      stat.percent = @computePercent studentsNum, stat

    courseSummary.percent = @computePercent studentsNum, courseSummary

    finalKPStats = _.indexBy statsArray, 'lectureId'
    finalKPStats.stats = courseStats
    finalKPStats.summary = courseSummary
    return finalKPStats


  computePercent: (studentsNum, stat) ->
    return stat.correctNum * 100 // (studentsNum * stat.total)

  makeKPStatsForSpecifiedLecture: (lecture, user) ->
    questionIds = _u.union lecture.quizzes, lecture.homeworks
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
#      tmpResult.myQKAs = myQKAs
#      tmpResult.myKPsCount = @getKPsCountFromQKAs myQKAs
      tmpResult.myQKAMap = _.indexBy myQKAs, 'questionId'

      resolveResult.stats = @transformKPsCountToMap @getKPsCountFromQKAs myQKAs
      do Q.resolve
    .then () ->
      condition = lectureId: lectureId
      condition.userId = user._id if user.role is 'student'

      HomeworkAnswer.findQ condition
    .then (homeworkAnswers) ->
      tmpResult.homeworkAnswers = homeworkAnswers
      condition =
        questionId:
          $in: questionIds
        lectureId: lectureId
      condition.userId = user._id if user.role is 'student'

      QuizAnswer.findQ condition
    .then (quizAnswers) =>
      tmpResult.quizAnswers = quizAnswers

      @updateCorrectNumForStats(
        resolveResult.stats
        tmpResult.myQKAMap
        tmpResult.quizAnswers
        tmpResult.homeworkAnswers
      )

      return resolveResult

  updateCorrectNumForStats: (stats, myQKAMap, quizAnswers, homeworkAnswers) ->
    for quizAnswer in quizAnswers
      if quizAnswer.result.toString() is myQKAMap[quizAnswer.questionId].answer
        for kp in myQKAMap[quizAnswer.questionId].kps
          stats[kp].correctNum++

    for homeworkAnswer in homeworkAnswers
      for one in homeworkAnswer.result
        if one.answer.toString() is myQKAMap[one.questionId].answer
          for kp in myQKAMap[one.questionId].kps
            stats[kp].correctNum++


  transformKPsCountToMap: (myKPsCount) ->
    return _.indexBy (for kpId, count of myKPsCount
      kpId: kpId
      total: count
      correctNum: 0
      percent: 0
    ), 'kpId'


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


  getQuizStats: (lectureId, questionId, optionsNum, students) ->
    QuizAnswer.find
      lectureId: lectureId
      questionId: questionId
      userId: {'$in': students}
    .populate('userId', '_id username name')
    .execQ()
    .then (quizAnswers) ->
      stats = {}
      stats['unanswered'] = JSON.parse(JSON.stringify(students));
      for idx in [0..optionsNum-1]
        stats[idx.toString()] = []

      for quizAnswer in quizAnswers
        for result in quizAnswer.result
          stats[result].push(quizAnswer.userId)
          # TODO: index the array!
          # TODO: stats's structure need to be discussed
          _.remove stats['unanswered'], (user) ->
            return user._id == quizAnswer.userId.id

      return stats


  getQuestionStats : (questionId) ->
    

  makeQuizStatsPromiseForSpecifiedLecture: (lecture, user) ->
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
      condition =
        questionId:
          $in: questionIds
        lectureId: lecture._id
      condition.userId = user._id if user.role is 'student'

      QuizAnswer.findQ condition
    .then (quizAnswers) =>
#      logger.info "quizAnswers:"
#      logger.info quizAnswers
      tmpResult.quizAnswers = quizAnswers
      resolveResult.correctNum = @computeCorrectNumByQuizAnswers(#更新correctNum
        tmpResult.myQAMap, tmpResult.quizAnswers
      )

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
        @makeQuizStatsPromiseForSpecifiedLecture lecture, user

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
    .then (questions) =>
      map = _.reduce(questions, (result, question) =>
        result[question.id] = @getAnswerStringFromQuestion question
        return result
      , {})
      return map
    , (err) ->
      Q.reject err


  computeCorrectNumByQuizAnswers: (myQAMap, quizAnswers) ->
    return _.reduce(quizAnswers, (sum, quizAnswer) ->
      if quizAnswer.result.toString() is myQAMap[quizAnswer.questionId]
        sum++
      return sum
    , 0)


  computeCorrectNumByHKAnswers: (myQAMap, homeworkAnswers) ->
    return _.reduce(homeworkAnswers, (sum, hkAnswer) ->
      return sum + _.reduce(hkAnswer.result, (innerSum, one) ->
        if one.answer.toString() is myQAMap[one.questionId]
          innerSum++
        return innerSum
      , 0)
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
