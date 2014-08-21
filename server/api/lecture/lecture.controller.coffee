
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /lecture              ->  index
# * POST    /lecture              ->  create
# * GET     /lecture/:id          ->  show
# * PUT     /lecture/:id          ->  update
# * DELETE  /lecture/:id          ->  destroy
# 

_ = require("lodash")
Lecture = require("./lecture.model")
Course = require("../course/course.model")

exports.index = (req, res) ->
  courseId = req.query.courseId
  if courseId
    Lecture.findOne
      courseId: courseId
    , (err, lecture) ->
      return handleError(res, err)  if err
      return res.send(404)  unless lecture
      if req.user.role is "teacher"
        Course.findOne
          _id: courseId
          owners:
            $in: [req.user.id]
        , (err, course) ->
          return handleError(res, err)  if err
          return res.send(404)  unless course
          res.json 200, lecture

      else if req.user.role is "student"
        Course.findById(courseId).populate(
          path: "classes"
          match:
            students:
              $in: [req.user.id]
        ).exec (err, course) ->
          return handleError(res, err)  if err
          return res.send(404)  if not course or 0 is course.classes.length
          res.json 200, lecture

      else if req.user.role is "admin"
        res.json 200, lecture
      else
        res.send 404
      return

  else
    res.send 404

exports.show = (req, res) ->
  Lecture.findById req.params.id, (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    courseId = lecture.courseId
    if req.user.role is "teacher"
      Course.findOne
        _id: courseId
        owners:
          $in: [req.user.id]
      , (err, course) ->
        return handleError(res, err)  if err
        return res.send(404)  unless course
        res.json 200, lecture

    else if req.user.role is "student"
      Course.findById(courseId).populate(
        path: "classes"
        match:
          students:
            $in: [req.user.id]
      ).exec (err, course) ->
        return handleError(res, err)  if err
        return res.send(404)  if not course or 0 is course.classes.length
        res.json 200, lecture

    else if req.user.role is "admin"
      res.json 200, lecture
    else
      res.send 404
    return


# TODO: add lectureID to classProcess's lectures automatically & keep the list order same as Course's lectureAssembly.
exports.create = (req, res) ->
  Course.findOne(
    _id: req.body.courseId
    owners:
      $in: [req.user.id]
  ).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    Lecture.create req.body, (err, lecture) ->
      return handleError(res, err)  if err
      course.lectureAssembly.push lecture._id
      course.save (err) ->
        return handleError(err)  if err # TODO: should use transactions to rollback..
        res.json 201, lecture


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Lecture.findById req.params.id, (err, lecture) ->
    return handleError(err)  if err
    return res.send(404)  unless lecture
    Course.findOne(
      _id: lecture.courseId
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      updated = _.merge(lecture, req.body)
      updated.save (err) ->
        return handleError(err)  if err
        res.json 200, lecture

# TODO: delete from classe's lectureAssembly & classProgress's lecturesStatus
exports.destroy = (req, res) ->
  Lecture.findById req.params.id, (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    Course.findOne(
      _id: lecture.courseId
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      lecture.remove (err) ->
        return handleError(res, err)  if err
        res.send 204


handleError = (res, err) ->
  res.send 500, err
