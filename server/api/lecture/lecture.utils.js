(function() {
  var BaseUtils;

  BaseUtils = require('../../common/BaseUtils').BaseUtils;

  exports.LectureUtils = BaseUtils.subclass({
    classname: 'LectureUtils',
    getAuthedLectureById: function(user, lectureId) {
      var Course, CourseUtils, Lecture, mCourse;
      CourseUtils = _u.getUtils('course');
      Course = _u.getModel('course');
      Lecture = _u.getModel('lecture');
      mCourse = void 0;
      return Course.findOneQ({
        lectureAssembly: lectureId
      }).then(function(course) {
        mCourse = course;
        return CourseUtils.getAuthedCourseById(user, mCourse._id);
      }).then(function(course) {
        return Lecture.findOneQ({
          _id: lectureId
        });
      });
    }
  });

}).call(this);

//# sourceMappingURL=lecture.utils.js.map
