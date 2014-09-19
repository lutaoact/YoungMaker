
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /lecture              ->  index
# * POST    /lecture              ->  create
# * GET     /lecture/:id          ->  show
# * PUT     /lecture/:id          ->  update
# * DELETE  /lecture/:id          ->  destroy
# 

Lecture = _u.getModel "lecture"
Course = _u.getModel "course"
CourseUtils = _u.getUtils 'course'
LectureUtils = _u.getUtils 'lecture'
Classe = _u.getModel 'classe'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'
request = require 'request'

exports.index = (req, res, next) ->
  courseId = req.query.courseId
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly'
  .then (course) ->
    return res.send course.lectureAssembly
  , next

exports.show = (req, res, next) ->
  lectureId = req.params.id
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    options = [
      path: 'keyPoints.kp'
    ,
      path: 'homeworks'
    ,
      path: 'quizzes'
    ]
    lecture.populateQ options
  .then (lecture) ->
    res.send lecture
  , (err) ->
    next err


# TODO: add lectureID to classProcess's lectures automatically & keep the list order same as Course's lectureAssembly.
exports.create = (req, res, next) ->
  courseId = req.query.courseId
  tmpResult = {}
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    tmpResult.course = course
    Lecture.createQ req.body
  .then (lecture) ->
    tmpResult.lecture = lecture
    tmpResult.course.lectureAssembly.push lecture._id
    do tmpResult.course.saveQ #TODO: should rollback creating lecture part
  .then () ->
    Classe.getAllStudents tmpResult.course.classes
  .then (studentIds) ->
    NoticeUtils.addLectureNotices studentIds, tmpResult.lecture._id
  .then (notices) ->
    SocketUtils.sendNotices notices
  .then () ->
    res.send tmpResult.lecture
  , (err) ->
    next err


exports.update = (req, res, next) ->
  lectureId = req.params.id
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    delete req.body._id  if req.body._id
    updated = _.extend lecture, req.body
    updated.markModified 'slides'
    updated.markModified 'keyPoints'
    updated.markModified 'quizzes'
    updated.markModified 'homeworks'
    if config.assetHost.videos == 'azure' && req.body.media?
      #TODO: cache token!
      request.post {
        uri: config.azure.acsBaseAddress
        form:
          grant_type: 'client_credentials'
          client_id: config.azure.accountName
          client_secret: config.azure.accountKey
          scope: 'urn:WindowsAzureMediaServices'
        strictSSL: true
      }, (err, response) ->
        access_token = JSON.parse(response.body).access_token
        request.get {
          uri: config.azure.shaAPIServerAddress+'CreateFileInfos'
          qs:
            assetid: "'"+req.body.media.split('/')[0]+"'"
          headers: config.azure.defaultHeaders(access_token)
        }, (err, response)->
          if err? then logger.error err

    updated.save (err) ->
      next err if err
      res.send updated
  , (err) ->
    next err


# TODO: delete from classProgress's lecturesStatus
exports.destroy = (req, res, next) ->
  lectureId = req.params.id
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    Lecture.removeQ
      _id : lectureId
  .then () ->
    Course.findOneQ
      lectureAssembly : lectureId
  .then (course) ->
    _.remove course.lectureAssembly
    , (id) ->
      id.toString() is lectureId
    course.markModified "lectureAssembly"
    course.save (err) ->
      next err if err
      res.send 204
  , (err) ->
    next err
