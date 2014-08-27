#key为collection的名字 value为数组
module.exports =
  category: do () ->
    (name: value for value in ['初一物理', '初二物理', '初三物理'])
  user: [
    provider: 'local'
    name: 'Test User'
    email: 'test@test.com'
    password: 'test'
  ,
    provider: 'local'
    role: 'admin'
    name: 'Admin'
    email: 'admin@admin.com'
    password: 'admin'
  ,
    provider: 'local'
    role: 'teacher'
    name: 'Teacher'
    email: 'teacher@teacher.com'
    password: 'teacher'
  ,
    provider: 'local'
    role: 'student'
    name: 'Student'
    email: 'student@student.com'
    password: 'student'
  ]
  key_point: [
    name: '三种淡黄色固体'
  ,
    name: 'AgBr的光解'
  ]
  organization: [
    uniqueName : 'cloud3'
    name : 'Cloud3 Edu'
    logo : 'http://cloud3edu.com/logo.jpg'
    description : 'This is a test organization'
    type : 'school'
  ,
    uniqueName : 'shangkele'
    name : 'shang kele'
    logo : 'http://shangkele.com/logo.jpg'
    description : 'This is a shangkele organization'
    type : 'school'
  ]

#console.log module.exports
