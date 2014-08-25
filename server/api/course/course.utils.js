(function() {
  var BaseUtils;

  BaseUtils = require('../../common/BaseUtils').BaseUtils;

  exports.CourseUtils = BaseUtils.subclass({
    classname: 'CourseUtils',
    getAuthedCourseById: function(user, courseId, cb) {
      switch (user.role) {
        case 'student':
          return this.checkStudent(user._id, courseId);
        case 'teacher':
          return this.checkTeacher(user._id, courseId);
      }
    },
    checkTeacher: function(teacherId, courseId) {
      var Course;
      Course = _u.getModel('course');
      return Course.findOneQ({
        _id: courseId,
        owners: teacherId
      }).then(function(course) {
        if (course != null) {
          return course;
        } else {
          return Q.reject({
            errCode: ErrCode.CannotReadThisCourse,
            errMsg: 'do not have permission on this course'
          });
        }
      }, function(err) {
        return Q.reject(err);
      });
    },
    checkStudent: function(studentId, courseId) {
      var Classe, Course;
      Classe = _u.getModel('classe');
      Course = _u.getModel('course');
      return Classe.findOneQ({
        students: studentId
      }).then(function(classe) {
        return Course.findOneQ({
          _id: courseId,
          classes: classe._id
        });
      }).then(function(course) {
        if (course != null) {
          return course;
        } else {
          return Q.reject({
            errCode: ErrCode.CannotReadThisCourse,
            errMsg: 'do not have permission on this course'
          });
        }
      }, function(err) {
        return Q.reject(err);
      });
    }
  });

}).call(this);

//# sourceMappingURL=course.utils.js.map
