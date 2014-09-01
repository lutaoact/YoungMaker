'use strict'

Course = _u.getModel 'course'
CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'

exports.teacherView = (req, res, next) ->
  courseId = req.query.courseId


exports.studentView = (req, res, next) ->
  courseId = req.query.courseId
  userId = req.user.id

  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    console.dir course
    course.populateQ 'lectureAssembly', 'name'
  .then (course) ->
    promiseArray = []
    _.forEach course.lectureAssembly, (lecture) ->
      console.log 'LectureId is: ' + lecture._id
      findAnswer = HomeworkAnswer.findOneQ
        userId : userId
        lectureId : lecture._id
      promiseArray.push findAnswer

    Q.all promiseArray
  .then (answers) ->
    console.log 'Answers are: '
    console.dir answers
    res.send 200
  , (err) ->
    next err




