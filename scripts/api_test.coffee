require '../server/common/init'

Course = _u.getModel 'course'
Classe = _u.getModel 'classe'
Category = _u.getModel 'category'
Organization = _u.getModel 'organization'

setup = ->
  # create category
  Category.createQ
    name : 'music'
  .then (category) ->
    console.log 'Created category:'
    console.dir category

    # create org
    Organization.createQ
      name : 'Cloud3'
      logo : 'http://cloud3edu.com/logo.jpg'
      subDomain: 'cloud3'
  , (error) ->
    console.log 'Failed to create category:'
    console.dir error


# check if a given user has access to a given course
getAuthedCourseById = (userId, courseId, cb) ->
  deferred = do Q.defer
  Classe.findOneQ
    students :
      $in : [userId]
  .then (classe) ->
    if not classe?
      deferred.resolve null
    else
      console.log 'Found classe...'
      console.dir classe
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

  ###
getAuthedCourseById '53d085b46850008f9b91a9ff', '53d085b46850008f9b91a9fe'
.then (course) ->
  console.log 'Course is'
  console.dir course
, (error) ->
  console.log 'Error is '
  console.dir error
###


