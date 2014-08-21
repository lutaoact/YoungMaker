(function() {
  var Course, Lecture, handleError, _;

  _ = require("lodash");

  Lecture = _u.getModel("lecture");

  Course = _u.getModel("course");

  exports.index = function(req, res) {
    var courseId;
    courseId = req.query.courseId;
    if (courseId) {
      return Lecture.findOne({
        courseId: courseId
      }, function(err, lecture) {
        if (err) {
          return handleError(res, err);
        }
        if (!lecture) {
          return res.send(404);
        }
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
    } else {
      return res.send(404);
    }
  };

  exports.show = function(req, res) {
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

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=lecture.controller.js.map
