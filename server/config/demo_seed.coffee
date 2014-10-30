'use strict'
require '../common/init'

unless process.env.orgId?
  console.log "注意看用法："
  console.log "Usage: orgId=xxxxx coffee demo_seed.coffee"
  process.exit 1

orgId = process.env.orgId

{StudentId, TeacherId, ClasseId, CourseId, UserNum} = Const.Demo
name    = 'Demo 学生 %s'
email   = 'student%s_demo@cloud3edu.cn'

module.exports =
  user: (for i in [0...UserNum]
    _id: _s.sprintf StudentId, i
    provider: 'local'
    role: 'student'
    username: _s.sprintf 'student%s_demo', i
    name: _s.sprintf name, i
    email: _s.sprintf email, i
    password: 'student'
    orgId: orgId
    avatar: ''
  ).concat [
    _id: TeacherId
    provider: 'local'
    role: 'teacher'
    username: 'teacher_demo'
    name: '演示老师'
    email: 'teacher_demo@cloud3edu.cn'
    password: 'teacher'
    orgId: orgId
    avatar: ''
  ]
  classe: [
    _id: ClasseId
    name : 'Demo 演示组'
    orgId: orgId
    students : []
    yearGrade : '2014'
  ]
#  course: [
#    _id: CourseId
#    name : 'Cloud3Edu Platform Introduction'
#    thumbnail : 'http://lorempixel.com/300/300/'
#    info : '简介'
#    owners : [ TeacherId ]
#    classes : [ ClasseId ]
#    lectureAssembly: []
#  ]

#console.log module.exports
require('./seed') module.exports
