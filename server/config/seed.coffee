
# Populate DB with sample data on server start
# to disable, edit config/environment/index.js, and set `seedDB: false`

'use strict'
require '../common/init'
AsyncClass = require('../common/AsyncClass').AsyncClass

seedData = require './seed_data'

removeAndCreate = (name, data) ->
  Model = _u.getModel name

  Model.removeQ {}
  .then () ->
    Model.createQ data
  .then (docs) ->
    return docs
  , (err) ->
    Q.reject err

actions = (removeAndCreate name, data for name, data of seedData)

User     = _u.getModel 'user'
Classe   = _u.getModel 'classe'
Course   = _u.getModel 'course'
Category = _u.getModel 'category'
Organization = _u.getModel 'organization'

orgId = undefined
ownerId = undefined
studentId = undefined
categoryId = undefined

Q.all actions
.then (results) ->
  User.findOneQ
    email: 'teacher@teacher.com'
.then (user) ->
  ownerId = user.id
  Category.findOneQ {}
.then (category) ->
  categoryId = category.id
  Organization.findOneQ
    uniqueName: 'cloud3'
.then (organization) ->
  orgId = organization.id
  User.findOneQ
    email: 'student@student.com'
.then (student) ->
  studentId = student.id
  removeAndCreate 'classe',
    name : 'Class one'
    orgId : orgId
    students : [studentId]
    yearGrade : '2014'
.then (classe) ->
  removeAndCreate 'course',
    name : 'Music 101'
    categoryId : categoryId
    thumbnail : 'http://test.com/thumb.jpg'
    info : 'This is course music 101'
    owners : [ownerId]
    classes : [classe._id]
, (err) ->
  console.log err
.finally () ->
  do process.exit
