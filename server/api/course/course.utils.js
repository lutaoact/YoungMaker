(function() {
  var Classe, Course, Q;

  Q = require('q');

  Course = _u.getModel('course');

  Classe = _u.getModel('classe');

  exports.getAuthedCourseById = function(user, courseId, cb) {
    var deferred;
    deferred = Q.defer();
    if (user.role === 'teacher') {
      Course.findOneQ({
        _id: courseId,
        owners: {
          $in: [user.id]
        }
      }).then(function(course) {
        if (course == null) {
          return deferred.resolve(null);
        } else {
          return deferred.resolve(course);
        }
      }, function(err) {
        return deferred.reject(err);
      });
    } else if (user.role === 'student') {
      Classe.findOneQ({
        students: {
          $in: [user.id]
        }
      }).then(function(classe) {
        if (classe == null) {
          return deferred.resolve(null);
        } else {
          return Course.findOneQ({
            classes: {
              $in: [classe._id]
            }
          });
        }
      }).then(function(course) {
        if (course == null) {
          return deferred.resolve(null);
        } else {
          if (course._id.toString() === courseId) {
            return deferred.resolve(course);
          } else {
            return deferred.resolve(null);
          }
        }
      }, function(err) {
        return deferred.reject(err);
      });
    }
    return deferred.promise.nodeify(cb);
  };

}).call(this);

//# sourceMappingURL=course.utils.js.map
