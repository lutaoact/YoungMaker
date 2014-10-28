'use strict'

StatsUtils  = _u.getUtils 'stats'
LectureUtils = _u.getUtils 'lecture'
User        = _u.getModel 'user'
Question    = _u.getModel 'question'
HomeworkAnswer = _u.getModel 'homework_answer'
Course = _u.getModel "course"
CourseUtils = _u.getUtils 'course'
LectureUtils = _u.getUtils 'lecture'
Classe = _u.getModel 'classe'
findIndex = _u.findIndex

buildQuizResult = (lectureId, qId, students) ->
  Question.findByIdQ qId
  .then (question) ->
    optionsNum = question.choices.length
    StatsUtils.getQuizStats lectureId, qId, optionsNum, students


buildHWResult = (lectureId, questionId, students) ->
  HomeworkAnswer.find
    lectureId : lectureId
    userId: {'$in': students}
  .populate('userId', '_id username name')
  .execQ()
  .then (hwas) ->
    # hwResult object to save middle result like this:
    # key : questionId
    # value : Array of answers for this question. For example
    # [{userId:"xxx", result: [0,1]} ...]
    hwResult = _.reduce hwas, (tmpResult, hwa) ->
      results = hwa.result
      _.forEach results, (result) ->
        qId = result.questionId
        if qId.toString() != questionId
          return
        tmpResult[qId] = [] if !tmpResult.hasOwnProperty qId
        answer = {userId: hwa.userId, result: result.answer}
        tmpResult[qId].push answer
      return tmpResult
    , {}

    answers = hwResult[questionId]
    qId = questionId
    Question.findByIdQ qId
    .then (question) ->
      stats = {}
      stats['unanswered'] = JSON.parse(JSON.stringify(students));
      optionsNum = question.choices.length
      for idx in [0..optionsNum-1]
        stats[idx.toString()] = []

      for answer in answers
        for result in answer.result
          stats[result].push(answer.userId)
        _.remove stats['unanswered'], (user) ->
          return user._id == answer.userId.id

      return stats


exports.questionStats = (req, res, next) ->
  lectureId = req.query.lectureId
  courseId = req.query.courseId
  classId = req.query.classId
  questionId = req.query.questionId
  logger.info "Get stats for lecture #{lectureId}"

  studentsPromise = null
  if courseId
    studentsPromise = CourseUtils.getAuthedCourseById req.user, courseId
    .then (course) ->
      Classe.getAllStudentsInfo(course.classes)
  else if courseId
    studentsPromise = Classe.getAllStudentsInfo [classId]
  else
    return next("need classId or courseId")

  user = req.user
  Q.all [studentsPromise, LectureUtils.getAuthedLectureById user, lectureId]
  .spread (students, lecture) ->
    if findIndex(lecture.quizzes, questionId) >= 0
      buildQuizResult lectureId, questionId, students
    else if findIndex(lecture.homeworks, questionId) >=0
      buildHWResult lectureId, questionId, students
    else
      throw new Error("question #{questionId} cannot find in lecture #{lectureId}")
  .then (result) ->
    res.send 200, result
  .fail next
  .done()

