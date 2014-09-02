###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /quiz_stats             ->  index
 * POST    /quiz_stats             ->  create
 * GET     /quiz_stats/:id          ->  show
 * DELETE  /quiz_stats/:id          ->  destroy
 ###

'use strict'

CourseUtils = _u.getUtils 'course'
StatsUtils = _u.getUtils 'stats'
Question = _u.getModel 'question'
QuizAnswer = _u.getModel 'quiz_answer'

exports.teacherView = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  middleResult = {}
  studentsNum = undefined

  CourseUtils.getStudentsNum user, courseId
  .then (num) ->
    studentsNum = num
    CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name quizzes'
  .then (course) ->
    logger.info course
    promiseArray = for lecture in course.lectureAssembly
      questionIds = lecture.quizzes
      middleResult[lecture.id] =
        name: lecture.name
        questionsLength: questionIds.length

      tmpResult = {}

      StatsUtils.buildQAMap questionIds
      .then (myQAMap) ->
        tmpResult.myQAMap = myQAMap
        QuizAnswer.findQ
          questionId:
            $in: questionIds
          lectureId: lecture._id
      .then (quizAnswers) ->
        tmpResult.quizAnswers = quizAnswers
        StatsUtils.computeCorrectNumByQuizAnswers(
          tmpResult.myQAMap, tmpResult.quizAnswers
        )
      .then (sum) ->
        middleResult[lecture.id].correctNum = sum
        return Q(sum)
    Q.all promiseArray
  .then () ->
    logger.info middleResult
    StatsUtils.computeFinalStats studentsNum, middleResult
  .then (finalStats) ->
    logger.info middleResult
    res.send finalStats
  , (err) ->
    next err

exports.studentView = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name quizzes'
  .then (course) ->
    logger.info course
    res.send course
  , (err) ->
    next err

