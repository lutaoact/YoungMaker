
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /course              ->  index
 * POST    /course              ->  create
 * GET     /course/:id          ->  show
 * PUT     /course/:id          ->  update
 * DELETE  /course/:id          ->  destroy
 */

(function() {
  'use strict';
  var Course, handleError, _;

  _ = require('lodash');

  Course = require('./course.model');

  exports.index = function(req, res) {
    Course
      .find({'owners': {$in: [req.user.id]}})
      .populate('classes', '_id name orgId yearGrade')
      .exec(function(err, courses) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, courses);
    });
  };

  exports.show = function(req, res) {
    Course
      .findById(req.params.id)
      .exec(function(err, course) {
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
    Course
      .findById(req.params.id)
      .populate('lectureAssembly', '_id name')
      .exec(function(err, course) {
        if (err) {
          return handleError(res, err);
        }
        if (!course) {
          return res.send(404);
        }
        return res.json(course.lectureAssembly);
      });
  };

  exports.create = function(req, res) {
    req.body.owners = [req.user.id]
    return Course.create(req.body, function(err, course) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, course);
    });
  };

  // TODO: support update user list.
  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    //classes can only be added by creating class_progress.
    if (req.body.classes) {
      delete req.body.classes;
    }
    return Course.findOne({"_id": req.params.id, "owners": {$in: [req.user.id]}}, function(err, course) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!course) {
        return res.send(404);
      }
      updated = _.merge(course, req.body);
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

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=course.controller.js.map
