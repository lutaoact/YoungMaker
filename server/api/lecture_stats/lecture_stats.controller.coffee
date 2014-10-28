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
    StatsUtils.getQuizStats lectureId, qId, question, students


buildHWResult = (lectureId, questionId, students) ->
  answersPromise = HomeworkAnswer.find
    lectureId : lectureId
    userId: {'$in': students}
  .populate('userId', '_id username name')
  .execQ()
  .then (hwas) ->
    answers = _.reduce hwas, (tmpAnswers, hwa) ->
      results = hwa.result
      idx = _.findIndex results, (ele)->
        return ele.questionId.toString() == questionId
      answer = {userId: hwa.userId, result: results[idx].answer}
      tmpAnswers.push(answer)
      return tmpAnswers
    , []
    return answers

  Q.all [answersPromise, Question.findByIdQ questionId]
  .spread (answers, question)->
    stats = {}
    stats['right'] = []
    stats['wrong'] = []
    stats['unanswered'] = []
    optionsNum = question.choices.length
    for idx in [0..optionsNum-1]
      stats[idx.toString()] = []

    for answer in answers
      for result in answer.result
        stats[result].push(answer.userId)

      if answer.result.length == 0
        correct = -1
      else
        correct = question.choices.every (choice, index)->
          if choice.correct
            answer.result?.some (item)-> item is index
          else
            answer.result?.every (item)-> item isnt index
        correct = if correct then 1 else 0

      if correct == 1
        stats['right'].push answer.userId
      else if correct == 0
        stats['wrong'].push answer.userId
      else
        stats['unanswered'].push answer.userId

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

