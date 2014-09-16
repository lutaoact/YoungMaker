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
disTopicId   = '8888888888888888888888%02d'
disReplyId   = '9999999999999999999999%02d'
questionId   = 'aaaaaaaaaaaaaaaaaaaaaa%02d'
quizAnswerId = 'bbbbbbbbbbbbbbbbbbbbbb%02d'
hwAnswerId   = 'cccccccccccccccccccccc%02d'

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
    avatar: 'http://lorempixel.com/128/128/people/1'
  ,
    _id: _s.sprintf userId, 1
    provider: 'local'
    role: 'admin'
    name: 'Admin'
    email: 'admin@admin.com'
    password: 'admin'
    orgId: _s.sprintf orgId, 0
    avatar: 'http://lorempixel.com/128/128/people/2'
  ,
    _id: _s.sprintf userId, 2
    provider: 'local'
    role: 'teacher'
    name: 'Teacher'
    email: 'teacher@teacher.com'
    password: 'teacher'
    orgId: _s.sprintf orgId, 0
    avatar: 'http://lorempixel.com/128/128/people/3'
  ,
    _id: _s.sprintf userId, 3
    provider: 'local'
    role: 'student'
    name: 'Student3'
    email: 'student@student.com'
    password: 'student'
    orgId: _s.sprintf orgId, 0
    avatar: 'http://lorempixel.com/128/128/people/4'
  ,
    _id: _s.sprintf userId, 4
    provider: 'local'
    role: 'student'
    name: 'Student4'
    email: 'student@student4.com'
    password: 'student'
    orgId: _s.sprintf orgId, 0
    avatar: 'http://lorempixel.com/128/128/people/5'
  ,
    _id: _s.sprintf userId, 5
    provider: 'local'
    role: 'student'
    name: 'Student5'
    email: 'student@student5.com'
    password: 'student'
    orgId: _s.sprintf orgId, 0
    avatar: 'http://lorempixel.com/128/128/people/4'
  ,
    _id: _s.sprintf userId, 6
    provider: 'local'
    role: 'student'
    name: 'Student6'
    email: 'student@student6.com'
    password: 'student'
    orgId: _s.sprintf orgId, 0
    avatar: 'http://lorempixel.com/128/128/people/5'
  ]
  key_point: _.map [
    '力和物体的平衡'
    '直线运动'
    '牛顿运动定律'
    '曲线运动 万有引力'
    '动量'
    '机械能'
    '机械振动和机械波'
    '分子动理论 热和功 气体'
    '电场'
    '稳恒电流'
    '磁场'
    '电磁感应'
    '交变电流'
    ], (name, index) ->
      _id: _s.sprintf keyPointId, index
      name: name
      categoryId: _s.sprintf categoryId,
        if index < 5 then 0
        else if index < 10 then 1
        else 2
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
  ,
    _id: _s.sprintf classeId, 1
    name : 'Class two'
    orgId: _s.sprintf orgId, 0
    students : [
      _s.sprintf userId, 5
      _s.sprintf userId, 6
    ]
    yearGrade : '2015'
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
        thumb: "9Sb6o3b0yY/306.jpeg"
    )
    media: 'GEoTQHtOEs/Sample 2.mp4'
    keyPoints: [
      kp: _s.sprintf keyPointId, 0
      timestamp : 10
    ,
      kp: _s.sprintf keyPointId, 1
      timestamp : 30
    ,
      kp: _s.sprintf keyPointId, 2
      timestamp : 50
    ]
    quizzes : [
      _s.sprintf questionId, 0
      _s.sprintf questionId, 1
      _s.sprintf questionId, 2
      _s.sprintf questionId, 3
    ]
    homeworks : [
      _s.sprintf questionId, 1
      _s.sprintf questionId, 2
    ]
  ,
    _id: _s.sprintf lectureId, 1
    name : 'lecture 2'
    thumbnail: 'http://lorempixel.com/200/150'
    info: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.
           Recusandae, error molestiae'
    slides: (
      for i in [1..10]
        _id: _s.sprintf slideId, i
        thumb: "9Sb6o3b0yY/306.jpeg"
    )
    media: 'GEoTQHtOEs/Sample 2.mp4'
    keyPoints: [
      kp: _s.sprintf keyPointId, 0
      timestamp : 10
    ,
      kp: _s.sprintf keyPointId, 1
      timestamp : 30
    ,
      kp: _s.sprintf keyPointId, 2
      timestamp : 50
    ]
    quizzes : [
      _s.sprintf questionId, 0
      _s.sprintf questionId, 1
    ]
    homeworks : [
      _s.sprintf questionId, 1
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
      _s.sprintf classeId, 1
    ]
    lectureAssembly: [
      _s.sprintf lectureId, 0
      _s.sprintf lectureId, 1
    ]
  ,
    _id: _s.sprintf courseId, 1
    name : 'Music 102'
    categoryId: _s.sprintf categoryId, 0
    thumbnail : 'http://lorempixel.com/300/300/'
    info : 'This is course music 102'
    owners : [
      _s.sprintf userId, 2 #teacher
    ]
    classes : [
      _s.sprintf classeId, 0
      _s.sprintf classeId, 1
    ]
    lectureAssembly: [
      _s.sprintf lectureId, 0
      _s.sprintf lectureId, 1
    ]
  ]
  dis_topic: [
    _id: _s.sprintf disTopicId, 0
    postBy: _s.sprintf userId, 3
    courseId: _s.sprintf courseId, 0
    lectureId: _s.sprintf lectureId, 0
    title: 'first dis topic'
    content: 'this is the first dis topic'
    repliesNum: 2
    voteUpUsers: [
      _s.sprintf userId, 3
      _s.sprintf userId, 4
    ]
  ,
    _id: _s.sprintf disTopicId, 1
    postBy: _s.sprintf userId, 4
    courseId: _s.sprintf courseId, 0
    lectureId: _s.sprintf lectureId, 0
    title: 'second dis topic'
    content: 'this is the second dis topic'
    repliesNum: 0
    voteUpUsers: [
      _s.sprintf userId, 3
    ]
  ]
  dis_reply: [
    _id: _s.sprintf disReplyId, 0
    postBy: _s.sprintf userId, 3
    disTopicId: _s.sprintf disTopicId, 0
    content: 'this is the first dis reply'
    voteUpUsers: [
      _s.sprintf userId, 3
      _s.sprintf userId, 4
    ]
  ,
    _id: _s.sprintf disReplyId, 1
    postBy: _s.sprintf userId, 4
    disTopicId: _s.sprintf disTopicId, 0
    content: 'this is the second dis reply'
    voteUpUsers: [
      _s.sprintf userId, 3
    ]
  ]
  question: [
    _id: _s.sprintf questionId, 0
    orgId: _s.sprintf orgId, 0
    categoryId: _s.sprintf categoryId, 0
    keyPoints : [
      _s.sprintf keyPointId, 0
      _s.sprintf keyPointId, 1
      _s.sprintf keyPointId, 2
      _s.sprintf keyPointId, 3
    ]
    content:
      imageUrl: 'http://url.cn/LmqYv5'
      title: '1 + 1 = ？'
      body: [
        desc: '2'
        correct: true
      ,
        desc: '3'
        correct: true
      ,
        desc: '4'
        correct: true
      ,
        desc: '5'
      ]
    type: 1
    solution: '1 + 1 = 2太简单了，上课了'
  ,
    _id: _s.sprintf questionId, 1
    orgId: _s.sprintf orgId, 0
    categoryId: _s.sprintf categoryId, 0
    keyPoints : [
      _s.sprintf keyPointId, 1
      _s.sprintf keyPointId, 5
      _s.sprintf keyPointId, 6
    ]
    content:
      imageUrl: 'http://url.cn/N0Potq'
      title: 'BrAg光解生成什么'
      body: [
        desc: 'Br2 + Ag'
        correct: true
      ,
        desc: 'Ag'
      ,
        desc: 'Br2'
        correct: true
      ]
    type: 1
    solution: '连AgBr的光解都不会，高中没读吧'
  ,
    _id: _s.sprintf questionId, 2
    orgId: _s.sprintf orgId, 0
    categoryId: _s.sprintf categoryId, 1
    keyPoints : [
      _s.sprintf keyPointId, 2
      _s.sprintf keyPointId, 3
      _s.sprintf keyPointId, 4
    ]
    content:
      imageUrl: 'http://url.cn/N0Potq'
      title: '这是类别1的问题'
      body: [
        desc: '这是答案'
        correct: true
      ,
        desc: '这个不是'
      ,
        desc: '这个也不是'
      ]
    type: 1
    solution: '连AgBr的光解都不会，高中没读吧'
  ,
    _id: _s.sprintf questionId, 3
    orgId: _s.sprintf orgId, 0
    categoryId: _s.sprintf categoryId, 1
    keyPoints : [
      _s.sprintf keyPointId, 2
    ]
    content:
      imageUrl: 'http://url.cn/N0Potq'
      title: '这是第4个问题'
      body: [
        desc: '这是答案'
        correct: true
      ,
        desc: '这个不是'
      ,
        desc: '这个也不是'
      ]
    type: 1
    solution: '第4题，很简单'
  ]
  quiz_answer : [
    _id : _s.sprintf quizAnswerId, 0
    userId : _s.sprintf userId, 3
    lectureId : _s.sprintf lectureId, 0
    questionId : _s.sprintf questionId, 0
    result : [0..2]
  ,
    _id : _s.sprintf quizAnswerId, 1
    userId : _s.sprintf userId, 4
    lectureId : _s.sprintf lectureId, 0
    questionId : _s.sprintf questionId, 1
    result : [1]
  ,
    _id : _s.sprintf quizAnswerId, 2
    userId : _s.sprintf userId, 4
    lectureId : _s.sprintf lectureId, 1
    questionId : _s.sprintf questionId, 1
    result : [1]
  ,
    _id : _s.sprintf quizAnswerId, 3
    userId : _s.sprintf userId, 4
    lectureId : _s.sprintf lectureId, 0
    questionId : _s.sprintf questionId, 0
    result : [1..3]
  ]
  homework_answer : [
    _id : _s.sprintf hwAnswerId, 0
    userId : _s.sprintf userId, 3
    lectureId : _s.sprintf lectureId, 0
    result : [
      questionId : _s.sprintf questionId, 1
      answer : [0]
    ,
      questionId : _s.sprintf questionId, 2
      answer : [0]
    ]
    submitted : true
  ]
  learn_progress: [
    userId: _s.sprintf userId, 3
    courseId: _s.sprintf courseId, 0
    progress: [
      _s.sprintf lectureId, 0
      _s.sprintf lectureId, 1
    ]
  ,
    userId: _s.sprintf userId, 3
    courseId: _s.sprintf courseId, 1
    progress: [
      _s.sprintf lectureId, 1
    ]
  ]
  teach_progress: [
    userId: _s.sprintf userId, 2
    classeId: _s.sprintf classeId, 0
    courseId: _s.sprintf courseId, 0
    progress: [
      _s.sprintf lectureId, 0
      _s.sprintf lectureId, 1
    ]
  ,
    userId: _s.sprintf userId, 2
    classeId: _s.sprintf classeId, 1
    courseId: _s.sprintf courseId, 0
    progress: [
      _s.sprintf lectureId, 1
    ]
  ]
  schedule: [
    courseId: _s.sprintf courseId, 0
    classeId: _s.sprintf classeId, 1
    start: new Date('2014-09-03T10:00:00.000+08:00')
    end  : new Date('2014-09-03T11:40:00.000+08:00')
    until: new Date('2014-12-31T11:40:00.000+08:00')
  ,
    courseId: _s.sprintf courseId, 0
    classeId: _s.sprintf classeId, 0
    start: new Date('2014-09-03T14:00:00.000+08:00')
    end  : new Date('2014-09-03T15:40:00.000+08:00')
    until: new Date('2014-12-31T00:00:00.000+08:00')
  ]
  school: [
    require './xinqiao.json'
  ]

require('./seed') module.exports
#console.log module.exports.question[0]
#console.log module.exports.question[0].content
