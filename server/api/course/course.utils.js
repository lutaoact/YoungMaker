(function() {
  var BaseUtils, Course;

  BaseUtils = require('../../common/BaseUtils').BaseUtils;

  Course = _u.getModel('course');

  exports.CourseUtils = BaseUtils.subclass({
    classname: 'CourseUtils',
    getAuthedCourseById: function(user, courseId, cb) {
      switch (user.role) {
        case 'student':
          return this.checkStudent(user._id, courseId);
        case 'teacher':
          return this.checkTeacher(user._id, courseId);
        case 'admin':
          return this.checkAdmin(courseId);
      }
    },
    checkTeacher: function(teacherId, courseId) {
      return Course.findOneQ({
        _id: courseId,
        owners: teacherId
      }).then(function(course) {
        if (course != null) {
          return course;
        } else {
          return Q.reject({
            status: 403,
            errCode: ErrCode.CannotReadThisCourse,
            errMsg: 'No course found or no permission to read it'
          });
        }
      }, function(err) {
        return Q.reject(err);
      });
    },
    checkStudent: function(studentId, courseId) {
      var Classe;
      Classe = _u.getModel('classe');
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
            status: 403,
            errCode: ErrCode.CannotReadThisCourse,
            errMsg: 'No course found or no permission to read it'
          });
        }
      }, function(err) {
        return Q.reject(err);
      });
    },
    checkAdmin: function(courseId) {
      return Course.findOneQ({
        _id: courseId
      }).then(function(course) {
        return course || {};
      }, function(err) {
        return Q.reject(err);
      });
    },
    getTeacherCourses: function(teacherId) {
      return Course.find({
        owners: teacherId
      }).populate('classes', '_id name orgId yearGrade').execQ().then(function(courses) {
        return courses;
      }, function(err) {
        return Q.reject(err);
      });
    },
    getStudentCourses: function(studentId) {
      var Classe;
      Classe = _u.getModel('classe');
      return Classe.findOneQ({
        students: studentId
      }).then(function(classe) {
        return Course.find({
          classes: classe._id
        });
      }).then(function(courses) {
        return courses;
      }, function(err) {
        return Q.reject(err);
      });
    }
  });

}).call(this);

//# sourceMappingURL=course.utils.js.map
