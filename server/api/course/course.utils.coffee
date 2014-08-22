
Q = require 'q'

Course = modelMap['course']
Classe = modelMap['classe']

# check if a given user has access to a given course
exports.getAuthedCourseById = (userId, courseId, cb) ->
  deferred = do Q.defer
  Classe.findOneQ
    students :
      $in : [userId]
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
          if course._id is courseId
            deferred.resolve course
          else
            deferred.resolve null
  , (err) ->
    deferred.reject(err)

  deferred.promise.nodeify cb
