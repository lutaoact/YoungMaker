'use strict'
require '../server/common/init'

if process.argv.length < 4
  console.log "注意看用法："
  console.log "Usage: coffee build_info_for_org.coffee [uniqueName] [name]"
  process.exit 1

uniqueName = process.argv[2]
name       = process.argv[3]

Organization = _u.getModel 'organization'
User = _u.getModel 'user'
Classe = _u.getModel 'classe'

tmpResult = {}
organization = uniqueName: uniqueName, name: name, type: 'colledge'

Organization.findOneQ uniqueName: uniqueName
.then (org) ->
  if org?
    return org
  else
    return Organization.createQ organization #新增organization
.then (org) ->
  tmpResult.org = org

  adminAndTeacher = [
    username: "admin_#{uniqueName}"
    password: "admin_#{uniqueName}"
    email: "admin@#{uniqueName}.sh.cn"
    name: "#{name}管理员"
    role: 'admin'
    orgId: tmpResult.org._id
  ,
    username: "teacher1_#{uniqueName}"
    password: "teacher1_#{uniqueName}"
    email: "teacher1@#{uniqueName}.sh.cn"
    name: "#{name}老师1"
    role: 'teacher'
    orgId: tmpResult.org._id
  ]

  User.createQ adminAndTeacher
.then (adminAndTeacher) ->
  tmpResult.adminAndTeacher = adminAndTeacher

  students = for id in [1..10]
    username: "#{id}_#{uniqueName}"
    password: "#{id}_#{uniqueName}"
    email: "#{id}@#{uniqueName}.sh.cn"
    name: "#{name}学生#{id}"
    orgId: tmpResult.org._id

  User.createQ students
.then (students) ->
  tmpResult.students = students
  studentIds = _.pluck students, '_id'
  classe =
    name: "#{name}班级1",
    orgId: tmpResult.org._id,
    students: studentIds

  Classe.createQ classe
.then (classe) ->
  tmpResult.classe = classe

  console.log tmpResult
, (err) ->
  console.log err
