'use strict'
require '../server/common/init'

Organization = _u.getModel 'organization'
User = _u.getModel 'user'
Classe = _u.getModel 'classe'
studentsInfo = require './xqsh.json'
#studentsInfo = require './xqsh2.json'
#console.log _.keys(studentsInfo).length #143 #4958 - 143 * 2 - 2 = 4670(good job)

buildStudentsData = (studentsMap, orgId) ->
  return (for id, name of studentsMap
    username: "#{id}-xqsh"
    password: "#{id}-xqsh"
    email: "#{id}@xq.sh.cn"
    name: name
    orgId: orgId
  )

importOneClasse = (classename, studentsMap, orgId) ->
  students = buildStudentsData studentsMap, orgId
  User.createQ students
  .then (studentDocs) ->
    studentIds = _.pluck studentDocs, '_id'
    classe = name: classename, orgId: orgId, students: studentIds
    Classe.createQ classe

organization = uniqueName: 'xqsh', name: '上海新侨学院', type: 'colledge'
admin =
  username: "admin-xqsh"
  password: "admin-xqsh"
  email: "admin@xq.sh.cn"
  name: '上海新侨学院管理员'
  role: 'admin'

tmpResult = {}
Organization.findOneQ uniqueName: 'xqsh'
.then (orgDoc) ->
  if orgDoc?
    return orgDoc
  else
    return Organization.createQ organization
.then (org) ->
  tmpResult.org = org
  admin.orgId = org._id
  User.createQ admin
.then () ->
  promises = for classename, studentsMap of studentsInfo
    importOneClasse classename, studentsMap, tmpResult.org._id

  Q.all promises
.then (result) ->
  console.log result
, (err) ->
  console.log err
