Const =
  NoticeType:
    TopicVoteUp: 1
    ReplyVoteUp: 2
    Comment: 3
    Lecture: 4

  NoticeRef:
    1: 'disTopic'
    2: 'disReply'
    3: 'disTopic'
    4: 'lecture'

  PageSize:
    DisTopic: 10
    DisReply: 36
    Lecture: 10
    Course: 10

  QuestionType:
    Choice: 1

  Student:
    ViewLecture: 1

  Teacher:
    ViewLecture: 101 # start teaching view
    EditLecture: 102

  Demo:
    StudentId: 'ffffffffffff000000000%03d'
    TeacherId: 'ffffffffffff000000001000'
    ClasseId:  'ffffffffffff000000010000'
    CourseId:  'ffffffffffff000000100000'
    UserNum: if process?.env?.NODE_ENV is 'development' then 10 else 1000

module?.exports = Const
window?.Const = Const
