BaseUtils = require('../../common/BaseUtils').BaseUtils
Course = _u.getModel 'course'
Classe = _u.getModel 'classe'

exports.CourseUtils = BaseUtils.subclass
  classname: 'CourseUtils'

  getAuthedCourseById: (user, courseId) ->
    switch user.role
      when 'student' then return @checkStudent user, courseId
      when 'teacher' then return @checkTeacher user, courseId
      when 'admin'   then return @checkAdmin   user, courseId

  checkTeacher: (user, courseId) ->
    Course.findOneQ
      _id: courseId
      owners: user._id
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          status : 403
          errCode : ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'

  checkStudent: (user, courseId) ->
    Classe.findOneQ
      students: user._id
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

  checkAdmin : (user, courseId) ->
    Course.findById courseId
          .populate 'categoryId', 'orgId'
          .execQ()
    .then (course) ->
      if course?.categoryId?.orgId.toString() isnt user.orgId.toString()
        return Q.reject
          status : 403
          errCode: ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'

      return course


  getTeacherCourses : (teacherId) ->
    Course.find
      owners : teacherId
    .populate 'classes', '_id name orgId yearGrade'
    .populate 'owners', '_id name'
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
      Course.find
        classes : classe._id
      .populate 'owners', '_id name'
      .execQ()
    .then (courses) ->
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
