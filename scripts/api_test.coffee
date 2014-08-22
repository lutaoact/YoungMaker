require '../server/common/init'

Course = _u.getModel 'course'
Classe = _u.getModel 'classe'
Category = _u.getModel 'category'
Organization = _u.getModel 'organization'
User = _u.getModel 'user'

setup = ->

  orgId = ''
  ownerId = ''
  studentId = ''
  categoryId = ''

  User.findOneQ
    email : 'admin@admin.com'
  .then (user) ->
    ownerId = user._id
    # create category
    Category.createQ
      name : 'music'
  .then (category) ->
    console.log 'Created category:'
    console.dir category
    categoryId = category._id

    # create org
    Organization.createQ
      name : 'Cloud3 Edu'
      logo : 'http://cloud3edu.com/logo.jpg'
      uniqueName : 'cloud3'
      description : 'This is a test organization'
      type : 'school'
  .then (org) ->
    console.log 'Created organization:'
    console.dir org
    orgId = org._id
    User.findOneQ
      email : 'test@test.com'
  .then (user) ->
    studentId = user._id
    Classe.createQ
      name : 'Class one'
      orgId : orgId
      students : [studentId]
      yearGrade : '2014'

  .then (classe) ->
    console.log 'Created classe:'
    console.dir classe

    # create course
    Course.createQ
      name : 'Music 101'
      categoryId : categoryId
      thumbnail : 'http://test.com/thumb.jpg'
      info : 'This is course music 101'
      owners : [ownerId]
      classes : [classe._id]

  .then (course) ->
    console.log 'Created course:'
    console.dir course
    process.exit code=0
  , (error) ->
    console.log 'Failed to create :'
    console.dir error
    process.exit code=1

cleanup = ->
  Category.findOneQ
    name : 'music'
  .then (category) ->
    console.log 'Remove category...'
    category.remove()
  .then () ->
    Organization.findOneQ
      uniqueName : 'cloud3'
  .then (org) ->
    console.log 'Remove organization...'
    org.remove()
    Classe.findOneQ
      name : 'Class one'
  .then (classe) ->
    console.log 'Remove classe...'
    classe.remove()
    process.exit code=0
  , (error) ->
    console.log 'Failed to remove '
    console.dir error
    process.exit code=1

#setup()
#cleanup()

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

getAuthedCourseById '53d085b46850008f9b91a9fe', '53f758fe7c375e1ca59592dc'
.then (course) ->
  console.log 'Authed course is '
  console.dir course
  process.exit code=0

