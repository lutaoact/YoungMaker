'use strict'

CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
StatsUtils = _u.getUtils 'stats'

calLectureStats = (lecture, summary, studentsNum, userId) ->
  tmpResult = {}
  questionIds = lecture.homeworks

  lectureStat =
    lectureId: lecture.id
    name: lecture.name
    questionsLength: questionIds.length
    correctNum: 0
    percent: 0

  condition =
    lectureId : lecture._id
  if userId? then condition.userId = userId

  HomeworkAnswer.findQ condition
  .then (answers) ->
    tmpResult.answers = answers
    StatsUtils.buildQAMap questionIds
  .then (qaMap) ->
    lectureStat.correctNum =
      StatsUtils.computeCorrectNumByHKAnswers qaMap, tmpResult.answers

    summary.questionsLength += lectureStat.questionsLength
    summary.correctNum += lectureStat.correctNum
    lectureStat.percent =
      lectureStat.correctNum * 100 //(studentsNum * lectureStat.questionsLength)

    return lectureStat
  , (err) ->
    Q.reject err

calStats = (user, courseId, studentsNum, userId) ->
  finalStats = {}
  summary =
    questionsLength: 0
    correctNum: 0
    percent: 0

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name homeworks'
  .then (course) ->
    lectures = course.lectureAssembly
    Q.all _.map lectures, (lecture) ->
      calLectureStats lecture, summary, studentsNum, userId
  .then (statsData) ->
    finalStats = _.indexBy statsData, 'lectureId'

    summary.percent =
      summary.correctNum * 100 // (summary.questionsLength * studentsNum)

    finalStats.summary = summary
    return finalStats

exports.show = (req, res, next) ->
  me = req.user
  role = me.role

  courseId = req.query.courseId

  (switch role
    when 'student'
      calStats me, courseId, 1, me.id
    when 'teacher'
      studentId = req.query.studentId
      if studentId?
        calStats me, courseId, 1, studentId
      else
        CourseUtils.getStudentsNum me, courseId
        .then (num) ->
          calStats me, courseId, num
  ).then (statsResult) ->
    res.json 200, statsResult
  , (err) ->
    next err
