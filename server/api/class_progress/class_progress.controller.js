
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /classProgress              ->  index
 * POST    /classProgress              ->  create
 * GET     /classProgress/:id          ->  show
 * PUT     /classProgress/:id          ->  update
 * DELETE  /classProgress/:id          ->  destroy
 */

(function() {
  'use strict';
  var ClassProgress, Course, handleError, _;

  _ = require('lodash');

  ClassProgress = require('./class_progress.model');
  Course = require('../course/course.model');

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

  // TODO: need to check if classId is in Course.
  exports.create = function(req, res) {
    req.body.userId = req.user.id;
    if (req.body.lecturesStatus) {
      delete req.body.lecturesStatus;
    }
    Course.findById(req.body.courseId, function(err, course){
      req.body.lecturesStatus = [];
      for (var i=0; i<course.lectureAssembly.length; i++) {
        console.log(course.lectureAssembly[i]);
        req.body.lecturesStatus.push({'lectureId': course.lectureAssembly[i], 'isFinished': false});
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
      if (err) {
        return handleError(err);
      }
      if (!classProgress) {
        return res.send(404);
      }
      updated = _.merge(classProgress, req.body);
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

//# sourceMappingURL=ClassProgress.controller.js.map
