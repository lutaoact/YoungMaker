BaseUtils = require('../../common/BaseUtils').BaseUtils
Course = _u.getModel 'course'
Classe = _u.getModel 'classe'
redisClient = require '../../common/redisClient'

courseCacheExpires = 24*60*60

exports.CourseUtils = BaseUtils.subclass
  classname: 'CourseUtils'

  getAuthedCourseById: (user, courseId) ->
    switch user.role
      when 'student' then return @checkStudent user._id, courseId
      when 'teacher' then return @checkTeacher user._id, courseId
      when 'admin' then return @checkAdmin courseId

  checkTeacher: (teacherId, courseId) ->
    key = teacherId + ':' + courseId
    
    redisClient.q.get key
    .then (cached) ->
      if cached?
        logger.info "Found course in cache for key #{key}"
        course = JSON.parse cached
        course = Course.newModel course
        return course
      
      Course.findOneQ
        _id: courseId
        owners: teacherId
      .then (course) ->
        if course?
          logger.info "Put course into cache for key #{key}"
          redisClient.q.set key, JSON.stringify(course.toJSON()), 'EX', courseCacheExpires
          return course
        else
          Q.reject
            status : 403
            errCode : ErrCode.CannotReadThisCourse
            errMsg : 'No course found or no permission to read it'

  checkStudent: (studentId, courseId) ->

    key = studentId + ':' + courseId
    
    redisClient.q.get key
    .then (cached) ->
      if cached?
        logger.info "Found course in cache for key #{key}"
        course = JSON.parse cached
        course = Course.newModel course
        return course
          
      Classe.findOneQ
        students: studentId
      .then (classe) ->
        Course.findOneQ
          _id: courseId
          classes: classe._id
      .then (course) ->
        if course?
          logger.info "Put course into cache for key #{key}"
          redisClient.q.set key, JSON.stringify(course.toJSON()), 'EX', courseCacheExpires
          return course
        else
          Q.reject
            status : 403
            errCode: ErrCode.CannotReadThisCourse
            errMsg : 'No course found or no permission to read it'

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
      Course.findQ
        classes : classe._id
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
