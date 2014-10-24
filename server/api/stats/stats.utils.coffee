BaseUtils = require('../../common/BaseUtils').BaseUtils
Question = _u.getModel 'question'
CourseUtils = _u.getUtils 'course'
QuestionUtils = _u.getUtils 'question'
QuizAnswer = _u.getModel 'quiz_answer'
UserAnswer = _u.getModel 'user_answer'
HomeworkAnswer = _u.getModel 'homework_answer'
User        = _u.getModel 'user'

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
    return QuestionUtils.getAnswerArrayFromQuestion(question).toString()


  getQuizStats: (lectureId, questionId) ->
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
      when 'teacher', 'admin' then return CourseUtils.getStudentsNum user, courseId
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

  computeUserAnswerStats: (userId) ->
    tmpResult = {}
    UserAnswer.findQ userId: userId
    .then (userAnswers) ->
      tmpResult.userAnswers = userAnswers
      questionIds = _.pluck userAnswers, 'questionId'
      Question.findQ _id: $in: questionIds
    .then (questions) =>
      tmpResult.questions = questions
      myQid2KALMap = {}
      myKPStats = {}
      for question in questions
        myQid2KALMap[question._id] =
          kps: question.keyPoints
          answer: @getAnswerStringFromQuestion question
          level: question.level

        for kp in question.keyPoints
          myKPStats[kp] ?= total: 0, totalLevel: 0, avgLevel: 0
          myKPStats[kp].total++

      @updateTotalLevelForStats tmpResult.userAnswers, myQid2KALMap, myKPStats
      @updateAvgLevelForStats myKPStats

      return myKPStats

  updateTotalLevelForStats: (userAnswers, myQid2KALMap, myKPStats) ->
    for userAnswer in userAnswers
      if userAnswer.result.toString() is myQid2KALMap[userAnswer.questionId].answer
        for kp in myQid2KALMap[userAnswer.questionId].kps
          myKPStats[kp].totalLevel += myQid2KALMap[userAnswer.questionId].level

  updateAvgLevelForStats: (myKPStats) ->
    for kpId, stat of myKPStats
      stat.avgLevel = stat.totalLevel // stat.total

  getQueryUser: (user, queryUserId, courseId) ->
    tmpResult = {}
    return (
      if ~(['teacher', 'admin'].indexOf user.role) and queryUserId?
        logger.info "#{user._id} is #{user.role}, I have queryUserId: #{queryUserId}"
        User.findByIdQ queryUserId
        .then (queryUser) ->
          if user.orgId.toString() isnt queryUser.orgId.toString()
            return Q.reject
              status : 403
              errCode : ErrCode.NotSameOrg
              errMsg : 'not the same org'

          tmpResult.queryUser = queryUser
        .then () ->
          CourseUtils.getAuthedCourseById user, courseId
        .then (course) ->
          return tmpResult.queryUser
      else
        Q(user)
    )
