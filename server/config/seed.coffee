
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
mClasse = undefined
mLecture = undefined
mTeacher = undefined
mStudent = undefined
mAdmin   = undefined

Q.all actions                          #加入所有静态数据
.then (results) ->
  Organization.findOneQ                #根据uniqueName查找organization
    uniqueName: 'cloud3'
.then (organization) ->
  orgId = organization.id
  User.findOneQ
    email: 'teacher@teacher.com'
.then (teacher) ->
  ownerId = teacher.id
  mTeacher = teacher
  mTeacher.orgId = orgId               #为teacher添加orgId字段
  do mTeacher.saveQ
.then () ->
  User.findOneQ
    email: 'admin@admin.com'
.then (admin) ->
  mAdmin = admin
  mAdmin.orgId = orgId                 #为admin添加orgId字段
  do mAdmin.saveQ
.then () ->
  User.findOneQ
    email: 'student@student.com'
.then (student) ->
  studentId = student.id
  mStudent = student
  mStudent.orgId = orgId               #为student添加orgId字段
  do mStudent.saveQ
.then () ->
  Category.findOneQ {}
.then (category) ->
  categoryId = category.id
  removeAndCreate 'classe',           #创建classe
    name : 'Class one'
    orgId : orgId
    students : [studentId]
    yearGrade : '2014'
.then (classe) ->
  mClasse = classe
  removeAndCreate 'lecture',          #创建lecture
    name : 'lecture 1'
.then (lecture) ->
  mLecture = lecture
  removeAndCreate 'course',           #创建course
    name : 'Music 101'
    categoryId : categoryId
    thumbnail : 'http://test.com/thumb.jpg'
    info : 'This is course music 101'
    owners : [ownerId]
    classes : [mClasse._id]
    lectureAssembly: [mLecture._id]
.then () ->
  console.log 'success'
, (err) ->
  console.log err
