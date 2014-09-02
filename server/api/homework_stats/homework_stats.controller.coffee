'use strict'

Course = _u.getModel 'course'
CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
Question = _u.getModel 'question'

exports.teacherView = (req, res, next) ->
  courseId = req.query.courseId


# calculate answer correctness percentage for each lecture in a course
# lectures : lectures in a course
# answers : user's answers for lectures above
# statsResult : object to store percentage result by lecture
calculatePercentage = (lectures, answers, statsResult, next) ->

  totalCourseQuestion = 0
  totalCorrectAnswer = 0

  _.forEach lectures, (lecture) ->

    totalLectureQuestions = lecture.homeworks.length
    totalCourseQuestion += totalLectureQuestions

    index = _.findIndex answers,
      lectureId : lecture._id
    logger.info 'Answer index is ' + index

    if index is -1 or totalLectureQuestions is 0
      statsResult.lectures.push
        lecture : lecture.name
        percentage : '0%'
    else
      # get questionMap for this lecture
      #questionsMap = QuestionUtils.getQuestionMap lecture.homeworks

      questionsMap = {}
      questionsMap[lecture.homeworks[0]] = '0'
      questionsMap[lecture.homeworks[1]] = '0'

      answer = answers[index]
      correctness = _.map answer.result, (result) ->
        questionId = result.questionId
        correctResult = questionsMap[questionId]
        myAnswer = result.answer.toString()
        return 1 if myAnswer is correctResult
        return 0

      correctNum = _.reduce correctness, (sum, num) -> sum+num
      totalCorrectAnswer += correctNum
      percentage = Math.floor (correctNum/totalLectureQuestions)*100

      statsResult.lectures.push
        lecture : lecture.name
        percentage : percentage + '%'

  # set summary field
  sumPercent = Math.floor (totalCorrectAnswer/totalCourseQuestion)*100
  statsResult.summary = sumPercent + '%'

exports.studentView = (req, res, next) ->
  courseId = req.query.courseId
  userId = req.user.id

  promiseArray = []
  statsResult =
    lectures : []
  lectures = []
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name homeworks'
  .then (course) ->
    lectures = course.lectureAssembly
    _.forEach lectures, (lecture) ->
      logger.info 'LectureId is: ' + lecture._id
      findAnswer = HomeworkAnswer.findOne
        userId : userId
        lectureId : lecture._id
      .populate 'result', 'questionId answer'
      .execQ()
      promiseArray.push findAnswer

    Q.all promiseArray
  .then (answers) ->
    calculatePercentage lectures, answers, statsResult, next
    res.json 200, statsResult

  , (err) ->
    next err
