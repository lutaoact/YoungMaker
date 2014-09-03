'use strict'

Course = _u.getModel 'course'
CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
Question = _u.getModel 'question'
StatsUtils = _u.getUtils 'stats'

calCorrectNum = (answer, qaMap) ->
  correctness = _.map answer.result, (result) ->
    questionId = result.questionId
    correctResult = qaMap[questionId]
    logger.info 'QuestionId is' + questionId
    logger.info 'CorrectResult is ' + correctResult
    myAnswer = result.answer.toString()
    logger.info 'My answer is ' + myAnswer
    return 1 if myAnswer is correctResult
    return 0

  logger.info 'correctness is %j', correctness
  _.reduce correctness, (sum, num) -> sum+num


lectureStats = (lecture, statsResult, studentsNum, userId) ->
  logger.info 'LectureId is ' + lecture._id
  logger.info 'UserId is ' + userId

  query = undefined
  if userId?
    query = HomeworkAnswer.find
      userId : userId
      lectureId : lecture._id
  else
    query = HomeworkAnswer.find
      lectureId : lecture._id

  query.populate 'result', 'questionId answer'
  .execQ()
  .then (answers) ->
    if not answers?  # no answer for the lecture
      statsResult.totalQ += lecture.homeworks.length
      {lecture : lecture.name, percentage : 0}
    else
      correctNum = 0
      qNum = lecture.homeworks.length
      StatsUtils.buildQAMap lecture.homeworks
      .then (qaMap) ->
        _.forEach answers, (answer) ->
          correctNum += calCorrectNum answer, qaMap

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
    calPromises = []
    _.forEach lectures, (lecture) ->
      cal = lectureStats lecture, statsResult, studentsNum, userId
      calPromises.push cal
    Q.all calPromises
  .then (statsData) ->
    statsResult.lectures = statsData
    logger.info 'total correctNum is '+ statsResult.totalCorrect
    logger.info 'totalQ is '+ statsResult.totalQ
    logger.info 'StudentNum is ' + studentsNum
    statsResult.summary = Math.floor (statsResult.totalCorrect)/((statsResult.totalQ)*studentsNum)*100
    delete statsResult.totalQ
    delete statsResult.totalCorrect
    statsResult


exports.studentView = (req, res, next) ->
  courseId = req.query.courseId
  me = req.user

  statsResult =
    lectures : []
    summary : 0
    totalQ : 0
    totalCorrect : 0

  calStats me, courseId, 1, statsResult, me.id
  .then (statsResult) ->
    res.json 200, statsResult
  , (err) ->
    next err


exports.teacherView = (req, res, next) ->
  courseId = req.query.courseId
  me = req.user
  userId = req.query.userId

  statsResult =
    lectures : []
    summary : 0
    totalQ : 0
    totalCorrect : 0

  CourseUtils.getStudentsNum req.user, courseId
  .then (num) ->
    if userId? # check one student's stats
      calStats me, courseId, 1, statsResult, userId
    else # check all students' stat in this course
      calStats me, courseId, num, statsResult
  .then (statsResult) ->
    res.json 200, statsResult
  , (err) ->
    next err

