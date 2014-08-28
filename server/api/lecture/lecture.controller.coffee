
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

exports.index = (req, res, next) ->
  courseId = req.query.courseId
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    Lecture.findQ
      _id :
        $in : course.lectureAssembly
  .then (lectures) ->
    return res.send lectures
  , (err) ->
    next err

exports.show = (req, res, next) ->
  lectureId = req.params.id
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    lecture.populateQ 'keyPoints', '_id name categoryId'
  .then (lecture) ->
    res.send lecture
  , (err) ->
    next err


# TODO: add lectureID to classProcess's lectures automatically & keep the list order same as Course's lectureAssembly.
exports.create = (req, res, next) ->
  courseId = req.query.courseId
  courseObj = {}
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    courseObj = course
    Lecture.createQ req.body
  .then (lecture) ->
    courseObj.lectureAssembly.push lecture._id
    courseObj.save (err) ->
      next err if err #TODO: should rollback creating lecture part
      res.send lecture
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
