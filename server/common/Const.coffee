
Const =
  NoticeType:
  # Like related notices
    LikeArticle: 1
    LikeCourse: 2
    LikeArticleComment: 3
    LikeCourseComment: 4

  # comment related notices
    ArticleComment: 5
    CourseComment: 6

  ActivityType:
    Article: 1

  CommentType:
    Article: 1
    Course: 2

  CommentRef:
    1: 'article'
    2: 'course'

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
    Default: 10
    Topic: 10
    Course: 10
    Article: 10
    Group: 10

module?.exports = Const
window?.Const = Const
