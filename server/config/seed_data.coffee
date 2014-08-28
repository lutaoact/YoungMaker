#key为collection的名字 value为数组
require '../common/init'
categoryId   = '0000000000000000000000%02d'
userId       = '1111111111111111111111%02d'
keyPointId   = '2222222222222222222222%02d'
orgId        = '3333333333333333333333%02d'
classeId     = '4444444444444444444444%02d'
lectureId    = '5555555555555555555555%02d'
courseId     = '6666666666666666666666%02d'
slideId      = '7777777777777777777777%02d'
discussionId = '7777777777777777777777%02d'

module.exports =
  category: (
    for value, i in ['初一物理', '初二物理', '初三物理']
      _id: _s.sprintf categoryId, i
      name: value
  )
  user: [
    _id: _s.sprintf userId, 0
    provider: 'local'
    name: 'Test User'
    email: 'test@test.com'
    password: 'test'
  ,
    _id: _s.sprintf userId, 1
    provider: 'local'
    role: 'admin'
    name: 'Admin'
    email: 'admin@admin.com'
    password: 'admin'
    orgId: _s.sprintf orgId, 0
  ,
    _id: _s.sprintf userId, 2
    provider: 'local'
    role: 'teacher'
    name: 'Teacher'
    email: 'teacher@teacher.com'
    password: 'teacher'
    orgId: _s.sprintf orgId, 0
  ,
    _id: _s.sprintf userId, 3
    provider: 'local'
    role: 'student'
    name: 'Student'
    email: 'student@student.com'
    password: 'student'
    orgId: _s.sprintf orgId, 0
  ,
    _id: _s.sprintf userId, 4
    provider: 'local'
    role: 'student'
    name: 'Student'
    email: 'student@student4.com'
    password: 'student'
    orgId: _s.sprintf orgId, 0
  ]
  key_point: [
    _id: _s.sprintf keyPointId, 0
    name: '三种淡黄色固体'
    categoryId: _s.sprintf categoryId, 0
  ,
    _id: _s.sprintf keyPointId, 1
    name: 'AgBr的光解'
    categoryId: _s.sprintf categoryId, 0
  ,
    _id: _s.sprintf keyPointId, 2
    name: '1+2等于3'
    categoryId: _s.sprintf categoryId, 1
  ]
  organization: [
    _id: _s.sprintf orgId, 0
    uniqueName : 'cloud3'
    name : 'Cloud3 Edu'
    logo : 'http://cloud3edu.com/logo.jpg'
    description : 'This is a test organization'
    type : 'school'
  ,
    _id: _s.sprintf orgId, 1
    uniqueName : 'shangkele'
    name : 'shang kele'
    logo : 'http://shangkele.com/logo.jpg'
    description : 'This is a shangkele organization'
    type : 'school'
  ]
  classe: [
    _id: _s.sprintf classeId, 0
    name : 'Class one'
    orgId: _s.sprintf orgId, 0
    students : [
      _s.sprintf userId, 3
      _s.sprintf userId, 4
    ]
    yearGrade : '2014'
  ]
  lecture: [
    _id: _s.sprintf lectureId, 0
    name : 'lecture 1'
    thumbnail: 'http://lorempixel.com/200/150'
    info: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.
           Recusandae, error molestiae'
    slides: (
      for i in [1..10]
        _id: _s.sprintf slideId, i
        thumb: "http://lorempixel.com/480/360/?r=#{i}"
    )
    media: 'gqaDmRfIab/1.mp4'
    keypoints: [
      {
        kp: _s.sprintf keyPointId, 0
        timestamp : 10
      },
      {
        kp: _s.sprintf keyPointId, 1
        timestamp : 30
      },
      {
        kp: _s.sprintf keyPointId, 2
        timestamp : 50
      }
    ]
  ]
  course: [
    _id: _s.sprintf courseId, 0
    name : 'Music 101'
    categoryId: _s.sprintf categoryId, 0
    thumbnail : 'http://lorempixel.com/300/300/'
    info : 'This is course music 101'
    owners : [
      _s.sprintf userId, 2 #teacher
    ]
    classes : [
      _s.sprintf classeId, 0
    ]
    lectureAssembly: [
      _s.sprintf lectureId, 0
    ]
  ]
  discussion: [
    _id: _s.sprintf discussionId, 0
    postBy: _s.sprintf userId, 3
    courseId: _s.sprintf courseId, 0
    lectureId: _s.sprintf lectureId, 0
    content: 'this is the first discussion'
    voteUpUsers: [
      _s.sprintf userId, 3
      _s.sprintf userId, 4
    ]
  ,
    _id: _s.sprintf discussionId, 1
    postBy: _s.sprintf userId, 4
    courseId: _s.sprintf courseId, 0
    lectureId: _s.sprintf lectureId, 0
    content: 'this is the second discussion'
    voteUpUsers: [
      _s.sprintf userId, 3
    ]
  ]

#console.log module.exports
