BaseUtils = require('../../common/BaseUtils').BaseUtils
Course = _u.getModel 'course'
Classe = _u.getModel 'classe'

exports.CourseUtils = BaseUtils.subclass
  classname: 'CourseUtils'

  getAuthedCourseById: (user, courseId) ->
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
          errMsg : 'No course found or no permission to read it'
    , (err) ->
      Q.reject err

  checkStudent: (studentId, courseId) ->

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
          status : 403
          errCode: ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'
    , (err) ->
      Q.reject err

  checkAdmin : (courseId) ->
    Course.findOneQ
      _id: courseId
    .then (course) ->
      return course if course?
      Q.reject
        status : 404
        errCode: ErrCode.CannotReadThisCourse
        errMsg : 'No course found or no permission to read it'
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
      console.log 'Classe found...'
      console.dir classe
      #if not classe? then return null
      Course.findQ
        classes : classe._id
    .then (courses) ->
      console.log 'Found courses ...'
      console.dir courses
      return courses
    , (err) ->
      Q.reject err

  getStudentsNum: (user, courseId) ->
    if user.role isnt 'teacher'
      return Q.reject
        status : 403
        errCode: ErrCode.TeacherCanAccessOnly
        errMsg : 'teacher can access only'

    @checkTeacher user._id, courseId
    .then (course) ->
      Classe.findQ
        _id:
          $in: course.classes
    .then (classes) ->
      return _.reduce(classes, (sum, classe) ->
        return sum + classe.students.length
      , 0)
    , (err) ->
      Q.reject err
