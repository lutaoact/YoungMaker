'use strict'
require '../common/init'

orgId   = '333333333333333333333999'
{StudentId, TeacherId, ClasseId, CourseId, UserNum} = Const.Demo
name    = 'Student%s'
email   = 'student%s@cloud3edu.cn'

module.exports =
  user: (for i in [0...UserNum]
    _id: _s.sprintf StudentId, i
    provider: 'local'
    role: 'student'
    name: _s.sprintf name, i
    email: _s.sprintf email, i
    password: 'student'
    orgId: orgId
    avatar: 'http://lorempixel.com/128/128/people/4'
  ).concat [
    _id: TeacherId
    provider: 'local'
    role: 'teacher'
    name: 'Teacher1000'
    email: 'teacher1000@cloud3edu.cn'
    password: 'teacher'
    orgId: orgId
    avatar: 'http://lorempixel.com/128/128/people/3'
  ]
  classe: [
    _id: ClasseId
    name : '在座的朋友们'
    orgId: orgId
    students : []
    yearGrade : '2014'
  ]
  course: [
    _id: CourseId
    name : 'Cloud3Edu Platform Introduction'
    thumbnail : 'http://lorempixel.com/300/300/'
    info : '简介'
    owners : [ TeacherId ]
    classes : [ ClasseId ]
    lectureAssembly: []
  ]

#console.log module.exports
require('./seed') module.exports
