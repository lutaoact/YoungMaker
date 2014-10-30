'use strict'
require '../server/common/init'

if process.argv.length < 3
  console.log "注意看用法："
  console.log "Usage: coffee create_answers_for_course.coffee [courseId]"
  process.exit 1

courseId = process.argv[2]
Course = _u.getModel 'course'
Lecture = _u.getModel 'lecture'
Classe = _u.getModel 'classe'
Question = _u.getModel 'question'
QuestionUtils = _u.getUtils 'question'
AnswerUtils = _u.getUtils 'answer'
QuizAnswer = _u.getModel 'quiz_answer'
HomeworkAnswer = _u.getModel 'homework_answer'

tmpResult = {}
Course.findByIdQ courseId
.then (course) ->
  tmpResult.course = course
  Q.all [
    Classe.findQ  _id: $in: course.classes
    Lecture.findQ _id: $in: course.lectureAssembly
  ]
.then (result) ->
  tmpResult.classes  = result[0]
  tmpResult.lectures = result[1]

  tmpResult.studentIds = _.flatten(_.pluck tmpResult.classes, 'students')

  tmpResult.quizzes = []; tmpResult.homeworks = []
  for lecture in tmpResult.lectures
    tmpResult.quizzes   = tmpResult.quizzes.concat   lecture.quizzes
    tmpResult.homeworks = tmpResult.homeworks.concat lecture.homeworks

  tmpResult.questionIds = _u.union tmpResult.quizzes, tmpResult.homeworks

  Question.findQ _id: $in: tmpResult.questionIds
.then (questions) ->
  tmpResult.questions = questions
  tmpResult.myQAMap = QuestionUtils.getQAMap tmpResult.questions

  promiseArray = for lecture in tmpResult.lectures
    Q.all [
      QuizAnswer.createQ AnswerUtils.buildTestQuizAnswers(
        tmpResult.studentIds
        lecture
        tmpResult.myQAMap
      )
      HomeworkAnswer.createQ AnswerUtils.buildTestHomeworkAnswers(
        tmpResult.studentIds
        lecture
        tmpResult.myQAMap
      )
    ]

  Q.all promiseArray
.then (answers) ->
#  console.log answers
#  console.log tmpResult
  console.log 'success'
, (err) ->
  console.log err
