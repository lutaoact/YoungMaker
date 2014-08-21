(function() {
  "use strict";
  var ClassProgress, Course, handleError, _;

  _ = require("lodash");

  ClassProgress = _u.getModel("class_progress");

  Course = _u.getModel("course");

  exports.index = function(req, res) {
    return ClassProgress.find(function(err, classProgresses) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, classProgresses);
    });
  };

  exports.show = function(req, res) {
    return ClassProgress.findById(req.params.id, function(err, classProgress) {
      if (err) {
        return handleError(res, err);
      }
      if (!classProgress) {
        return res.send(404);
      }
      return res.json(classProgress);
    });
  };

  exports.create = function(req, res) {
    req.body.userId = req.user.id;
    if (req.body.lecturesStatus) {
      delete req.body.lecturesStatus;
    }
    return Course.findById(req.body.courseId, function(err, course) {
      var lecture, _i, _len, _ref;
      req.body.lecturesStatus = [];
      _ref = course.lectureAssembly;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        lecture = _ref[_i];
        req.body.lecturesStatus.push({
          'lectureId': lecture,
          'isFinished': false
        });
      }
      return ClassProgress.create(req.body, function(err, classProgress) {
        if (err) {
          return handleError(res, err);
        }
        return res.json(201, classProgress);
      });
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return ClassProgress.findById(req.params.id, function(err, classProgress) {
      var updated;
      updated = void 0;
      if (err) {
        return handleError(err);
      }
      if (!classProgress) {
        return res.send(404);
      }
      updated = _.extend(classProgress, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, classProgress);
      });
    });
  };

  exports.destroy = function(req, res) {
    return ClassProgress.findById(req.params.id, function(err, classProgress) {
      if (err) {
        return handleError(res, err);
      }
      if (!classProgress) {
        return res.send(404);
      }
      return classProgress.remove(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.send(204);
      });
    });
  };

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=class_progress.controller.js.map
