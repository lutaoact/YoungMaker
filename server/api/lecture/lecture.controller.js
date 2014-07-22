
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /lecture              ->  index
 * POST    /lecture              ->  create
 * GET     /lecture/:id          ->  show
 * PUT     /lecture/:id          ->  update
 * DELETE  /lecture/:id          ->  destroy
 */

(function() {
  'use strict';
  var Lecutre, Course, handleError, _;

  _ = require('lodash');

  Lecutre = require('./lecture.model');
  Course = require('../course/course.model');

  exports.index = function(req, res) {
    var courseId = req.query.courseId;
    if (courseId) {
      return Lecutre.findOne({"courseId": courseId}, function(err, lecture) {
        if (err) {
          return handleError(res, err);
        }
        if (!lecture) {
          return res.send(404);
        }
        // only course's owner can get lectures
        if (req.user.role == "teacher") {
          Course.findOne({"_id": courseId, "owners": {$in: [req.user.id]} }, function(err, course){
            if (err) return handleError(res, err);
            if (!course) return res.send(404);
            return res.json(200, lecture);
          });
        }
        else if (req.user.role == "student") {
          Course
          .findById(courseId)
          .populate({
            path: 'classes',
            match: {'students': {$in: [req.user.id]}}
          })
          .exec(function(err, course){
            if (err) return handleError(res, err);
            if ( !course || 0 == course.classes.length) return res.send(404);
            return res.json(200, lecture);
          });
        }
        else if (req.user.role == "admin")
        {
          return res.json(200, lecture);
        }
        else {
          return res.send(404);
        }
      });
    }
    else {
      return res.send(404);
    }
  };

  exports.show = function(req, res) {
    return Lecutre.findById(req.params.id, function(err, lecture) {
      if (err) {
        return handleError(res, err);
      }
      if (!lecture) {
        return res.send(404);
      }

      var courseId = lecture.courseId;
      // only course's owner can get lectures
      if (req.user.role == "teacher") {
        Course.findOne({"_id": courseId, "owners": {$in: [req.user.id]} }, function(err, course){
          if (err) return handleError(res, err);
          if (!course) return res.send(404);
          return res.json(200, lecture);
        });
      }
      else if (req.user.role == "student") {
        Course
        .findById(courseId)
        .populate({
          path: 'classes',
          match: {'students': {$in: [req.user.id]}}
        })
        .exec(function(err, course){
          if (err) return handleError(res, err);
          if ( !course || 0 == course.classes.length) return res.send(404);
          return res.json(200, lecture);
        });
      }
      else if (req.user.role == "admin")
      {
        return res.json(200, lecture);
      }
      else {
        return res.send(404);
      }
    });
  };

  // TODO: support insert lecture to lecture list
  // TODO: add lectureID to classProcess's lectures automatically & keep the list order same as Course's lectureAssembly.
  exports.create = function(req, res) {
    Course
    .findOne({'_id': req.body.courseId, 'owners': {$in: [req.user.id]}})
    .exec(function(err, course){
      if (err) return handleError(res, err);
      if (!course) return res.send(404);

      return Lecutre.create(req.body, function(err, lecture) {
        if (err) {
          return handleError(res, err);
        }
        course.lectureAssembly.push(lecture._id);
        course.save(function(err) {
          if (err) return handleError(err); // TODO: should use transactions to rollback..
          return res.json(201, lecture);
        });
      });
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Lecutre.findById(req.params.id, function(err, lecture) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!lecture) {
        return res.send(404);
      }
      Course
      .findOne({'_id': lecture.courseId, 'owners': {$in: [req.user.id]}})
      .exec(function(err, course){
        if (err) return handleError(res, err);
        if (!course) return res.send(404);

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

  // TODO: delete from classe's lectureAssembly & classProgress's lecturesStatus
  exports.destroy = function(req, res) {
    return Lecutre.findById(req.params.id, function(err, lecture) {
      if (err) {
        return handleError(res, err);
      }
      if (!lecture) {
        return res.send(404);
      }
      Course
      .findOne({'_id': lecture.courseId, 'owners': {$in: [req.user.id]}})
      .exec(function(err, course){
        if (err) return handleError(res, err);
        if (!course) return res.send(404);
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

//# sourceMappingURL=Lecutre.controller.js.map
