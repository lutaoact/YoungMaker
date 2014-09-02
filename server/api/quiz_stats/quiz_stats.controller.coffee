###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /quiz_stats             ->  index
 * POST    /quiz_stats             ->  create
 * GET     /quiz_stats/:id          ->  show
 * DELETE  /quiz_stats/:id          ->  destroy
 ###

'use strict'

CourseUtils = _u.getUtils 'course'
Question = _u.getModel 'question'
QuizAnswer = _u.getModel 'quiz_answer'

exports.teacherView = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  logger.info req.query

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name quizzes'
  .then (course) ->
    findIndexBy = Q.nbind Question.findIndexBy, Question
    promiseArray = for lecture in course.lectureAssembly
      findIndexBy 'id', {_id: {$in: lecture.quizzes}}
      .then (questionMap) ->
        QuizAnswer

    Q.all promiseArray
  .then (result) ->
    logger.info result
    res.send result
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

