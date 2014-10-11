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

  tmpResult.quizzes = []; tmpResult.homeworks = []
  for lecture in tmpResult.lectures
    tmpResult.quizzes   = tmpResult.quizzes.concat   lecture.quizzes
    tmpResult.homeworks = tmpResult.homeworks.concat lecture.homeworks

  tmpResult.questionIds = _u.union tmpResult.quizzes, tmpResult.homeworks

  Question.findQ _id: $in: tmpResult.questionIds
.then (questions) ->
  tmpResult.questions = questions

  tmpResult.QAMap = QuestionUtils.getQAMap tmpResult.questions
.then () ->
  console.log tmpResult
  console.log 'success'
, (err) ->
  console.log err

#> db.courses.find({_id: ObjectId("541903807ba35abb020ffe33")})
#{ "_id" : ObjectId("541903807ba35abb020ffe33"), "thumbnail" : "AepnGmgEvp/space_1.jpg", "name" : "Space 101", "categoryId" : ObjectId("000000000000000000000002"), "info" : "This is the class about space.", "modified" : ISODate("2014-10-07T02:06:44.208Z"), "created" : ISODate("2014-09-17T03:44:00.044Z"), "classes" : [ ObjectId("444444444444444444444400"), ObjectId("54223a6ecf5b4bef2e45d60c") ], "owners" : [ ObjectId("111111111111111111111102") ], "lectureAssembly" : [ ObjectId("54191562c5014dbf037ad5b8"), ObjectId("541903ca7ba35abb020ffe34") ], "__v" : 22 }
#> db.lectures.find({_id: {$in: [ ObjectId("54191562c5014dbf037ad5b8"), ObjectId("541903ca7ba35abb020ffe34") ]}}, {quizzes: 1, homeworks: 1})
#{ "_id" : ObjectId("541903ca7ba35abb020ffe34"), "homeworks" : [ ObjectId("54350edf45fedb9684372392") ], "quizzes" : [ ObjectId("541e375f7b35e5601d92098e"), ObjectId("5430a786a66da68c5eb03282") ] }
#{ "_id" : ObjectId("54191562c5014dbf037ad5b8"), "homeworks" : [ ], "quizzes" : [ ObjectId("5434fb76978d0749835b4cf7"), ObjectId("5435002a978d0749835b4d0c"), ObjectId("5435068f45fedb968437237b") ] }
