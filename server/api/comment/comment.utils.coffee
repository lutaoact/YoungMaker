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
  typeStr = Const.CommentRef[data.type]
  noticeData = {}
  noticeData[typeStr+'Id'] = data[typeStr]._id
  NoticeUtils.addNotice targetUser, data.postBy, Const.NoticeType[_s.capitalize(typeStr)+'Comment'], noticeData


addCommentReferNotice = (referUserId, data)->
  typeStr = Const.CommentRef[data.type]
  noticeData = {}
  noticeData[typeStr+'Id'] = data[typeStr]._id
  NoticeUtils.addNotice referUserId, data.postBy, Const.NoticeType[_s.capitalize(typeStr)+'CommentRefer'], noticeData


class CommentUtils extends BaseUtils
  getCommentRefByType: (type) ->
    return _u.getModel Const.CommentModelRef[type]

  sendCommentNotices : (data, referUsers)->
    getMoreData(data)
    .then ()->
      getTargetUsers data
      notices = _.map data.targetUsers, (targetUser) ->
        addCommentNotice(
          targetUser
          data
        )

      # remove duplicated notices if author is equal to referUser
      _.remove referUsers, (referUser)->
        _u.isEqual data[Const.CommentRef[data.type]].author, referUser._id

      notices = _.union notices, _.map referUsers, (referUser)->
        addCommentReferNotice(
          referUser._id
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
