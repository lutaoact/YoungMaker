(function() {
  "use strict";
  var Course, CourseUtils, KnowledgePoint, Lecture, ObjectId, _;

  _ = require("lodash");

  Course = _u.getModel("course");

  Lecture = _u.getModel("lecture");

  KnowledgePoint = _u.getModel("knowledge_point");

  ObjectId = require("mongoose").Types.ObjectId;

  CourseUtils = _u.getUtils('course');

  exports.index = function(req, res, next) {
    var role, userId;
    userId = req.user.id;
    role = req.user.role;
    switch (role) {
      case 'teacher':
        return CourseUtils.getTeacherCourses(userId).then(function(courses) {
          return res.json(200, courses || []);
        }, function(err) {
          return next(err);
        });
      case 'student':
        return CourseUtils.getStudentCourses(userId).then(function(courses) {
          return res.json(200, courses || []);
        }, function(err) {
          return next(err);
        });
      case 'admin':
        return Course.findQ({}).then(function(courses) {
          return res.json(200, courses || []);
        }, function(err) {
          return next(err);
        });
    }
  };

  exports.show = function(req, res, next) {
    return CourseUtils.getAuthedCourseById(req.user, req.params.id).then(function(course) {
      return res.json(200, course || {});
    }, function(err) {
      return next(err);
    });
  };

  exports.create = function(req, res, next) {
    req.body.owners = [req.user.id];
    return Course.createQ(req.body).then(function(course) {
      return res.json(201, course);
    }, function(err) {
      return next(err);
    });
  };

  exports.update = function(req, res, next) {
    if (req.body._id) {
      delete req.body._id;
    }
    return CourseUtils.getAuthedCourseById(req.user, req.params.id).then(function(course) {
      var updated;
      updated = _.extend(course, req.body);
      updated.markModified('lectureAssembly');
      updated.markModified('classes');
      return updated.save(function(err) {
        if (err) {
          next(err);
        }
        return res.json(200, updated);
      });
    }, function(err) {
      return next(err);
    });
  };

  exports.destroy = function(req, res, next) {
    return CourseUtils.getAuthedCourseById(req.user, req.params.id).then(function(course) {
      console.log('Found course to delete');
      return Course.removeQ({
        _id: course._id
      });
    }).then(function() {
      return res.send(204);
    }, function(err) {
      return next(err);
    });
  };

}).call(this);

//# sourceMappingURL=course.controller.js.map
