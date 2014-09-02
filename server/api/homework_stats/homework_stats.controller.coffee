'use strict'

Course = _u.getModel 'course'
CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
Question = _u.getModel 'question'
StatsUtils = _u.getUtils 'stats'


correctPercent = (answer, qaMap, lecture) ->

  correctness = _.map answer.result, (result) ->
    questionId = result.questionId
    correctResult = qaMap[questionId]
    console.log 'CorrectResult is ' + correctResult
    myAnswer = result.answer.toString()
    console.log 'My answer is ' + myAnswer
    return 1 if myAnswer is correctResult
    return 0

  console.log 'correctness is %j', correctness
  correctNum = _.reduce correctness, (sum, num) -> sum+num
  console.log 'CorrectNum is ' + correctNum
  questionNum = lecture.homeworks.length
  Math.floor (correctNum/questionNum)*100

calculateByLecture = (userId, lecture, statsResult) ->
  logger.info 'LectureId is ' + lecture._id
  HomeworkAnswer.findOne
    userId : userId
    lectureId : lecture._id
  .populate 'result', 'questionId answer'
  .execQ()
  .then (answer) ->
    if not answer?  # not answer found for the lecture
      statsResult.lectures.push
        lecture : lecture.name
        percentage : 0
      statsResult.totalQ += lecture.homeworks.length
    else
      StatsUtils.buildQAMap lecture.homeworks
      .then (qaMap) ->
        percent = correctPercent(answer, qaMap, lecture)
        statsResult.totalQ += lecture.homeworks.length
        statsResult.summary += percent*(lecture.homeworks.length)
        statsResult.lectures.push
          lecture : lecture.name
          percentage : percent
  , (err) ->
    Q.reject err


exports.studentView = (req, res, next) ->
  courseId = req.query.courseId

  calPromises = []
  statsResult =
    lectures : []
    summary : 0
    totalQ : 0
  lectures = undefined

  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name homeworks'
  .then (course) ->
    lectures = course.lectureAssembly
    _.forEach lectures, (lecture) ->
      cal = calculateByLecture req.user.id, lecture, statsResult
      calPromises.push cal
    Q.all calPromises
  .then (data) ->
    console.log 'summary is '+ statsResult.summary
    console.log 'totalQ is '+ statsResult.totalQ
    statsResult.summary = Math.floor (statsResult.summary/statsResult.totalQ)
    delete statsResult.totalQ
    res.json 200, statsResult

  , (err) ->
    next err


exports.teacherView = (req, res, next) ->
  courseId = req.query.courseId
