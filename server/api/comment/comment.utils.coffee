BaseUtils = require('../../common/BaseUtils')
Course = _u.getModel 'course'
Article = _u.getModel 'article'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'
Notice = _u.getModel 'notice'


getMoreData = (data) ->
  switch data.type
    when Const.CommentType.Article
      Article.findByIdQ data.belongTo
      .then (article)->
        data.article = article

    when Const.CommentType.Course
      Course.findByIdQ data.belongTo
      .then (course)->
        data.course = course


getTargetUsers = (data) ->
  switch data.type
    when Const.CommentType.Article
      if data.article.author.equals data.postBy
        data.targetUsers = []
      else
        data.targetUsers = [data.article.author]

    when Const.CommentType.Course
      if data.course.author.equals data.postBy
        data.targetUsers = []
      else
        data.targetUsers = [data.course.author]


addCommentNotice = (targetUser, data)->
  switch data.type
    when Const.CommentType.Article
      noticeData =
        articleId: data.article._id
      NoticeUtils.addNotice targetUser, data.postBy, Const.NoticeType.ArticleComment, noticeData


    when Const.CommentType.Course
      noticeData =
        courseId: data.course._id
      NoticeUtils.addNotice targetUser, data.postBy, Const.NoticeType.CourseComment, noticeData


class CommentUtils extends BaseUtils
  getCommentRefByType: (type) ->
    return _u.getModel Const.CommentModelRef[type]

  sendCommentNotices : (data)->
    getMoreData(data)
    .then ()->
      getTargetUsers data
      notices = _.map data.targetUsers, (targetUser) ->
        addCommentNotice(
          targetUser
          data
        )
      Q.all notices
    .then (notices) ->
      SocketUtils.sendNotices notices
      # TODO: for mobile app
      #DeviceUtils.pushToUser notice for notice in notices

  removeCommentsAndNotices: (objectId) ->
    Q.all [
      Notice.removeByObjectId objectId
      Comment.removeByBelongTo objectId
    ]
    .then () ->
      console.log 'notices and comments are removed'


exports.Instance = new CommentUtils()
exports.Class = CommentUtils
exports.CommentUtils = CommentUtils
