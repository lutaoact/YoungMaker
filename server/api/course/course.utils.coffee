BaseUtils = require('../../common/BaseUtils').BaseUtils
Course = _u.getModel 'course'

exports.CourseUtils = BaseUtils.subclass
  classname: 'CourseUtils'

  getAuthedCourseById: (user, courseId, cb) ->
    switch user.role
      when 'student' then return @checkStudent user._id, courseId
      when 'teacher' then return @checkTeacher user._id, courseId
      when 'admin' then return @checkAdmin courseId

  checkTeacher: (teacherId, courseId) ->
    Course.findOneQ
      _id: courseId
      owners: teacherId
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          status : 403
          errCode : ErrCode.CannotReadThisCourse
          errMsg : 'do not have permission on this course'
    , (err) ->
      Q.reject err

  checkStudent: (studentId, courseId) ->

    Classe = _u.getModel 'classe'
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

  checkAdmin : (courseId) ->
    Course.findOneQ
      _id: courseId
    .then (course) ->
      return course || {}
    , (err) ->
      Q.reject err

  getTeacherCourses : (teacherId) ->
    Course.find
      owners : teacherId
    .populate 'classes', '_id name orgId yearGrade'
    .execQ()
    .then (courses) ->
      return courses
    , (err) ->
      Q.reject err

  getStudentCourses : (studentId) ->
    Classe = _u.getModel 'classe'
    Classe.findOneQ
      students: studentId
    .then (classe) ->
      #if not classe? then return null
      Course.find
        classes : classe._id
    .then (courses) ->
      return courses
    , (err) ->
      console.log 'Error...'
      console.dir err
      Q.reject err




