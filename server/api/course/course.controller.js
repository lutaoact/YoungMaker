(function() {
  "use strict";
  var Course, KnowledgePoint, Lecture, ObjectId, handleError, _;

  _ = require("lodash");

  Course = _u.getModel("course");

  Lecture = _u.getModel("lecture");

  KnowledgePoint = _u.getModel("knowledge_point");

  ObjectId = require("mongoose").Types.ObjectId;

  exports.index = function(req, res) {
    return Course.find({
      owners: {
        $in: [req.user.id]
      }
    }).populate("classes", "_id name orgId yearGrade").exec(function(err, courses) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, courses);
    });
  };

  exports.show = function(req, res) {
    return Course.findById(req.params.id).exec(function(err, course) {
      if (err) {
        return handleError(res, err);
      }
      if (!course) {
        return res.send(404);
      }
      return res.json(course);
    });
  };

  exports.showLectures = function(req, res) {
    return Course.findById(req.params.id).populate("lectureAssembly", "_id name").exec(function(err, course) {
      if (err) {
        return handleError(res, err);
      }
      if (!course) {
        return res.send(404);
      }
      return res.json(course.lectureAssembly);
    });
  };

  exports.showLecture = function(req, res) {
    return Lecture.findById(req.params.lectureId, function(err, lecture) {
      var courseId;
      if (err) {
        return handleError(res, err);
      }
      if (!lecture) {
        return res.send(404);
      }
      courseId = lecture.courseId;
      if (req.user.role === "teacher") {
        return Course.findOne({
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
        return Course.findById(courseId).populate({
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
        return res.json(200, lecture);
      } else {
        return res.send(404);
      }
    });
  };

  exports.create = function(req, res) {
    req.body.owners = [req.user.id];
    return Course.create(req.body, function(err, course) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, course);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    if (req.body.classes) {
      delete req.body.classes;
    }
    return Course.findOne({
      _id: req.params.id,
      owners: {
        $in: [req.user.id]
      }
    }, function(err, course) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!course) {
        return res.send(404);
      }
      updated = _.extend(course, req.body);
      updated.markModified("lectureAssembly");
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, course);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Course.findById(req.params.id, function(err, course) {
      if (err) {
        return handleError(res, err);
      }
      if (!course) {
        return res.send(404);
      }
      return course.remove(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.send(204);
      });
    });
  };

  exports.createLecture = function(req, res) {
    return Course.findOne({
      _id: req.params.id,
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
      req.body.courseId = req.params.id;
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

  exports.updateLecture = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Lecture.findById(req.params.lectureId, function(err, lecture) {
      var updated;
      updated = void 0;
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
        if (err) {
          return handleError(res, err);
        }
        if (!course) {
          return res.send(404);
        }
        updated = _.extend(lecture, req.body);
        return updated.save(function(err) {
          if (err) {
            return handleError(err);
          }
          return res.json(200, lecture);
        });
      });
    });
  };

  exports.destroyLecture = function(req, res) {
    return Lecture.findById(req.params.lectureId, function(err, lecture) {
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
          _.remove(course.lectureAssembly, new ObjectId(req.params.lectureId));
          course.markModified("lectureAssembly");
          return course.save(function(err) {
            if (err) {
              return handleError(res, err);
            }
            return res.send(204);
          });
        });
      });
    });
  };

  exports.createKnowledgePoint = function(req, res) {
    var updateLectureKnowledgePoints;
    updateLectureKnowledgePoints = function(knowledgePoint) {
      return Lecture.findByIdAndUpdate(req.params.lectureId, {
        $push: {
          knowledgePoints: knowledgePoint._id
        }
      }, function(err, lecture) {
        if (err) {
          return handleError(res, err);
        }
        return res.send(knowledgePoint);
      });
    };
    return Course.findOne({
      _id: req.params.id,
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
      if (req.body._id) {
        return updateLectureKnowledgePoints(req.body);
      } else {
        return KnowledgePoint.create(req.body, function(err, knowledgePoint) {
          if (err) {
            return handleError(err);
          }
          return updateLectureKnowledgePoints(knowledgePoint);
        });
      }
    });
  };

  exports.showKnowledgePoints = function(req, res) {
    return Lecture.findById(req.params.lectureId).populate("knowledgePoints").exec(function(err, lecture) {
      if (err) {
        return handleError(res, err);
      }
      if (!lecture) {
        return res.send(404);
      }
      return res.json(lecture.knowledgePoints);
    });
  };

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=course.controller.js.map
