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

buildQuizResult = (lecture, qIds, students) ->
  Q.all _.map qIds, (qId) ->
    question = null
    Question.findByIdQ qId
    .then (q) ->
      question = q
      optionsNum = q.content.body.length
      StatsUtils.getQuizStats lecture._id, qId, optionsNum, students
    .then (stats) ->
      return {
        question: question
        stats: stats
      }
  
buildHWResult = (lectureId) ->
  HomeworkAnswer.find
    lectureId : lectureId
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
        tmpResult[qId] = [] if !tmpResult.hasOwnProperty qId
        answer = {userId: hwa.userId, result: result.answer}
        tmpResult[qId].push answer
      return tmpResult
    , {}

    Q.all _.map hwResult , (answers, qId) ->
#      stats = _.countBy (_.flatten answers) , (answer) -> answer
      Question.findByIdQ qId
      .then (question) ->
        stats = {}
        optionsNum = question.content.body.length
        for idx in [0..optionsNum-1]
          stats[idx.toString()] = []

        for answer in answers
          for result in answer.result
            stats[result].push(answer.userId)

        return {
          question : question
          stats : stats
        }
  
  
exports.questionStats = (req, res, next) ->
  lectureId = req.query.lectureId
  courseId = req.query.courseId
  classId = req.query.classId
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
  finalResult = []
  Q.all [studentsPromise, LectureUtils.getAuthedLectureById user, lectureId]
  .then (students_lecture) ->
    students = students_lecture[0]
    lecture = students_lecture[1]
    quizIds = lecture.quizzes
    buildQuizResult lecture, quizIds, students
  .then (quizStats) ->
    finalResult = finalResult.concat quizStats
    # TODO: add unanswered students list for homework
    buildHWResult lectureId
  .then (hwStats) ->
    finalResult = finalResult.concat hwStats
    res.send 200, finalResult
  .fail (err) ->
    next err
      
