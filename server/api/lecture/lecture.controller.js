(function() {
  var Course, CourseUtils, Lecture, handleError;

  Lecture = _u.getModel("lecture");

  Course = _u.getModel("course");

  CourseUtils = _u.getUtils('course');

  exports.index = function(req, res, next) {
    var courseId;
    courseId = req.query.courseId;
    return CourseUtils.getAuthedCourseById(req.user, courseId).then(function(course) {
      return Lecture.findQ({
        _id: {
          $in: course.lectureAssembly
        }
      });
    }).then(function(lectures) {
      if (lectures != null) {
        return res.json(200, lectures);
      }
      return res.send(404);
    }, function(err) {
      return next(err);
    });
  };

  exports.show = function(req, res, next) {
    return Lecture.findById(req.params.id, function(err, lecture) {
      var courseId;
      if (err) {
        return handleError(res, err);
      }
      if (!lecture) {
        return res.send(404);
      }
      courseId = lecture.courseId;
      if (req.user.role === "teacher") {
        Course.findOne({
          _id: courseId,
          owners: {
            $in: [req.user.id]
          }
        }, function(err, course) {
          if (err) {
            return handleError(res, err);
          }
          if (!course) {
            return res.send(404);
          }
          return res.json(200, lecture);
        });
      } else if (req.user.role === "student") {
        Course.findById(courseId).populate({
          path: "classes",
          match: {
            students: {
              $in: [req.user.id]
            }
          }
        }).exec(function(err, course) {
          if (err) {
            return handleError(res, err);
          }
          if (!course || 0 === course.classes.length) {
            return res.send(404);
          }
          return res.json(200, lecture);
        });
      } else if (req.user.role === "admin") {
        res.json(200, lecture);
      } else {
        res.send(404);
      }
    });
  };

  exports.create = function(req, res) {
    return Course.findOne({
      _id: req.body.courseId,
      owners: {
        $in: [req.user.id]
      }
    }).exec(function(err, course) {
      if (err) {
        return handleError(res, err);
      }
      if (!course) {
        return res.send(404);
      }
      return Lecture.create(req.body, function(err, lecture) {
        if (err) {
          return handleError(res, err);
        }
        course.lectureAssembly.push(lecture._id);
        return course.save(function(err) {
          if (err) {
            return handleError(err);
          }
          return res.json(201, lecture);
        });
      });
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Lecture.findById(req.params.id, function(err, lecture) {
      if (err) {
        return handleError(err);
      }
      if (!lecture) {
        return res.send(404);
      }
      return Course.findOne({
        _id: lecture.courseId,
        owners: {
          $in: [req.user.id]
        }
      }).exec(function(err, course) {
        var updated;
        if (err) {
          return handleError(res, err);
        }
        if (!course) {
          return res.send(404);
        }
        updated = _.merge(lecture, req.body);
        return updated.save(function(err) {
          if (err) {
            return handleError(err);
          }
          return res.json(200, lecture);
        });
      });
    });
  };

  exports.destroy = function(req, res) {
    return Lecture.findById(req.params.id, function(err, lecture) {
      if (err) {
        return handleError(res, err);
      }
      if (!lecture) {
        return res.send(404);
      }
      return Course.findOne({
        _id: lecture.courseId,
        owners: {
          $in: [req.user.id]
        }
      }).exec(function(err, course) {
        if (err) {
          return handleError(res, err);
        }
        if (!course) {
          return res.send(404);
        }
        return lecture.remove(function(err) {
          if (err) {
            return handleError(res, err);
          }
          return res.send(204);
        });
      });
    });
  };


  /* copied from course.controller.coffee, need to implement all these logic in above methods
  
  exports.showLectures = (req, res) ->
    Course.findById(req.params.id).populate("lectureAssembly", "_id name").exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      res.json course.lectureAssembly
  
  
  exports.showLecture = (req, res) ->
    Lecture.findById req.params.lectureId, (err, lecture) ->
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
  
   *TODO: sync classProgress's lecturesStatus
  exports.createLecture = (req, res) ->
    Course.findOne(
      _id: req.params.id
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      req.body.courseId = req.params.id
      Lecture.create req.body, (err, lecture) ->
        return handleError(res, err)  if err
        course.lectureAssembly.push lecture._id
        course.save (err) ->
          return handleError(err)  if err #TODO: should use transactions to rollback..
          res.json 201, lecture
  
  
  exports.updateLecture = (req, res) ->
    delete req.body._id  if req.body._id
    Lecture.findById req.params.lectureId, (err, lecture) ->
      updated = undefined
      return handleError(err)  if err
      return res.send(404)  unless lecture
      Course.findOne(
        _id: lecture.courseId
        owners:
          $in: [req.user.id]
      ).exec (err, course) ->
        return handleError(res, err)  if err
        return res.send(404)  unless course
        updated = _.extend(lecture, req.body)
        updated.save (err) ->
          return handleError(err)  if err
          res.json 200, lecture
  
  
  exports.destroyLecture = (req, res) ->
    Lecture.findById req.params.lectureId, (err, lecture) ->
      return handleError(res, err)  if err
      return res.send(404)  unless lecture
      Course.findOne(
        _id: lecture.courseId
        owners:
          $in: [req.user.id]
      ).exec (err, course) ->
        return handleError(res, err)  if err
        return res.send(404)  unless course
         *delete from Course's lectureAssembly list
        lecture.remove (err) ->
          return handleError(res, err)  if err
          _.remove course.lectureAssembly, new ObjectId(req.params.lectureId)
          course.markModified "lectureAssembly"
          course.save (err) ->
            return handleError(res, err)  if err
            res.send 204
   */

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=lecture.controller.js.map
