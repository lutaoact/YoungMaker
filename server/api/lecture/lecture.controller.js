(function() {
  var Course, CourseUtils, Lecture, LectureUtils;

  Lecture = _u.getModel("lecture");

  Course = _u.getModel("course");

  CourseUtils = _u.getUtils('course');

  LectureUtils = _u.getUtils('lecture');

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
      return res.send(lectures);
    }, function(err) {
      return next(err);
    });
  };

  exports.show = function(req, res, next) {
    var lectureId;
    lectureId = req.params.id;
    return LectureUtils.getAuthedLectureById(req.user, lectureId).then(function(lecture) {
      return res.send(lecture);
    }, function(err) {
      return next(err);
    });
  };

  exports.create = function(req, res, next) {
    var courseId, courseObj;
    courseId = req.query.courseId;
    courseObj = {};
    return CourseUtils.getAuthedCourseById(req.user, courseId).then(function(course) {
      courseObj = course;
      return Lecture.createQ(req.body);
    }).then(function(lecture) {
      courseObj.lectureAssembly.push(lecture._id);
      return courseObj.save(function(err) {
        if (err) {
          next(err);
        }
        return res.send(lecture);
      });
    }, function(err) {
      return next(err);
    });
  };

  exports.update = function(req, res, next) {
    var lectureId;
    lectureId = req.params.id;
    return LectureUtils.getAuthedLectureById(req.user, lectureId).then(function(lecture) {
      var updated;
      if (req.body._id) {
        delete req.body._id;
      }
      updated = _.extend(lecture, req.body);
      updated.markModified('slides');
      updated.markModified('knowledgePoints');
      updated.markModified('quizzes');
      updated.markModified('homeworks');
      return updated.save(function(err) {
        if (err) {
          next(err);
        }
        return res.send(updated);
      });
    }, function(err) {
      return next(err);
    });
  };

  exports.destroy = function(req, res, next) {
    var lectureId;
    lectureId = req.params.id;
    return LectureUtils.getAuthedLectureById(req.user, lectureId).then(function(lecture) {
      return Lecture.removeQ({
        _id: lectureId
      });
    }).then(function() {
      return Course.findOneQ({
        lectureAssembly: lectureId
      });
    }).then(function(course) {
      _.remove(course.lectureAssembly, function(id) {
        return id.toString() === lectureId;
      });
      course.markModified("lectureAssembly");
      return course.save(function(err) {
        if (err) {
          next(err);
        }
        return res.send(204);
      });
    }, function(err) {
      return next(err);
    });
  };

}).call(this);

//# sourceMappingURL=lecture.controller.js.map
