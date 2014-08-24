
Q = require 'q'

Course = _u.getModel 'course'
Classe = _u.getModel 'classe'

# check if a given user has access to a course for a given courseId
exports.getAuthedCourseById = (user, courseId, cb) ->

  deferred = do Q.defer

  if user.role is 'teacher'
    Course.findOneQ
      _id : courseId
      owners :
        $in : [user.id]
    .then (course) ->
      if not course?
        deferred.resolve null
      else
        deferred.resolve course
    , (err) ->
        deferred.reject err

  else if user.role is 'student'
    Classe.findOneQ
      students :
        $in : [user.id]
    .then (classe) ->
      if not classe?
        deferred.resolve null
      else
        Course.findOneQ
          classes :
            $in : [classe._id]
    .then (course) ->
      if not course?
        deferred.resolve null
      else
        if course._id.toString() is courseId
          deferred.resolve course
        else
          deferred.resolve null
    , (err) ->
      deferred.reject(err)

  deferred.promise.nodeify cb
