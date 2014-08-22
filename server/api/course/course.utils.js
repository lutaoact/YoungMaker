(function() {
  var Classe, Course, Q;

  Q = require('q');

  Course = modelMap['course'];

  Classe = modelMap['classe'];

  exports.getAuthedCourseById = function(userId, courseId, cb) {
    var deferred;
    deferred = Q.defer();
    Classe.findOneQ({
      students: {
        $in: [userId]
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
    return deferred.promise.nodeify(cb);
  };

}).call(this);

//# sourceMappingURL=course.utils.js.map
