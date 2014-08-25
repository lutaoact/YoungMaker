BaseUtils = require('../../common/BaseUtils').BaseUtils

exports.CourseUtils = BaseUtils.subclass
  classname: 'CourseUtils'

  getAuthedCourseById: (user, courseId, cb) ->
    switch user.role
      when 'student' then return @checkStudent user._id, courseId
      when 'teacher' then return @checkTeacher user._id, courseId

  checkTeacher: (teacherId, courseId) ->
    Course = _u.getModel 'course'
    Course.findOneQ
      _id: courseId
      owners: teacherId
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          errCode: ErrCode.CannotReadThisCourse
          errMsg: 'do not have permission on this course'
    , (err) ->
      Q.reject err

  checkStudent: (studentId, courseId) ->
    Classe = _u.getModel 'classe'
    Course = _u.getModel 'course'

    Classe.findOneQ
      students: studentId
    .then (classe) ->
      Course.findOneQ
        _id: courseId
        classes: classe._id
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          errCode: ErrCode.CannotReadThisCourse
          errMsg: 'do not have permission on this course'
    , (err) ->
      Q.reject err
