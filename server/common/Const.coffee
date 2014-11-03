
Const =
  NoticeType:
    TopicVoteUp: 1
    ReplyVoteUp: 2
    Comment: 3
    Lecture: 4

  MsgType:
    Login: 'login'
    Notice: 'notice'
    Quiz: 'quiz'
    QuizAnswer: 'quiz_answer'
    Error: 'error'

  NoticeRef:
    1: 'disTopic'
    2: 'disReply'
    3: 'disReply'
    4: 'lecture'

  PageSize:
    DisTopic: 10
    DisReply: 36
    Lecture: 10
    Course: 10
    Question: 300

  QuestionType:
    Choice: 1
    Blank:  2

  Student:
    ViewLecture: 1

  Teacher:
    ViewLecture: 101 # start teaching view
    EditLecture: 102

module?.exports = Const
window?.Const = Const
