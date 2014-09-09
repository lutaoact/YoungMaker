'use strict'

Course = _u.getModel 'course'
CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
Question = _u.getModel 'question'
StatsUtils = _u.getUtils 'stats'

calCorrectNum = (answer, qaMap) ->
  _.reduce answer.result, (sum, item) ->
    questionId = item.questionId
    correctResult = qaMap[questionId]
    logger.info 'QuestionId is' + questionId
    logger.info 'CorrectResult is ' + correctResult
    myAnswer = item.answer.toString()
    logger.info 'My answer is ' + myAnswer
    return sum+1 if myAnswer is correctResult
    return sum
  , 0

initStatsResult = ->
    lectures : []
    summary : 0
    totalQ : 0
    totalCorrect : 0

calLectureStats = (lecture, statsResult, studentsNum, userId) ->
  logger.info 'LectureId is ' + lecture._id

  condition =
    lectureId : lecture._id

  if userId? then condition.userId = userId

  HomeworkAnswer.find condition
  .populate 'result', 'questionId answer'
  .execQ()
  .then (answers) ->
    if not answers?  # no answer for the lecture
      statsResult.totalQ += lecture.homeworks.length
      {lecture : lecture.name, percentage : 0}
    else
      qNum = lecture.homeworks.length
      StatsUtils.buildQAMap lecture.homeworks
      .then (qaMap) ->
        correctNum = _.reduce answers, (correctNum, answer) ->
          correctNum + calCorrectNum answer, qaMap
        , 0

        logger.info 'CorrectNum is ' + correctNum
        statsResult.totalQ += lecture.homeworks.length
        statsResult.totalCorrect += correctNum
        percent = Math.floor correctNum/(studentsNum*qNum)*100
        {lecture : lecture.name, percentage : percent}
  , (err) ->
    Q.reject err

calStats = (user, courseId, studentsNum, statsResult, userId) ->
  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name homeworks'
  .then (course) ->
    lectures = course.lectureAssembly
    Q.all _.map lectures, (lecture) ->
      calLectureStats lecture, statsResult, studentsNum, userId
  .then (statsData) ->
    statsResult.lectures = statsData
    logger.info 'total correctNum is '+ statsResult.totalCorrect
    logger.info 'totalQ is '+ statsResult.totalQ
    logger.info 'StudentNum is ' + studentsNum
    console.log 'start calculating summary...'
    statsResult.summary = Math.floor ((statsResult.totalCorrect)/((statsResult.totalQ)*studentsNum))*100
    console.log 'summary is ' + statsResult.summary
    delete statsResult.totalQ
    delete statsResult.totalCorrect
    statsResult

exports.show = (req, res, next) ->
  me = req.user
  role = me.role

  courseId = req.query.courseId
  statsResult = do initStatsResult

  switch role
    when 'student'
      calStats me, courseId, 1, statsResult, me.id
      .then (statsResult) ->
        res.json 200, statsResult
      , (err) ->
        next err
    when 'teacher'
      studentId = req.query.studentId
      console.log 'studentId is ' + studentId
      if studentId?
        calStats me, courseId, 1, statsResult, studentId
        .then (statsResult) ->
          console.dir statsResult
          res.json 200, statsResult
        , (err) ->
          next err
      else
        CourseUtils.getStudentsNum me, courseId
        .then (num) ->
          calStats me, courseId, num, statsResult
        .then (statsResult) ->
          res.json 200, statsResult
        , (err) ->
          next err
