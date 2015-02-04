BaseUtils = require '../../common/BaseUtils'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'

  
class LikeUtils extends BaseUtils
  createLike: (Model, objectId, userId) ->
    # we only want to send notice for like action, not for dislike action
    likeAction = false
    
    Model.findByIdQ objectId
    .then (object) ->
      if object.likeUsers.indexOf(userId) > -1
        object.likeUsers.pull userId
      else
        object.likeUsers.addToSet userId
        console.log "userId: #{userId} liked #{Model.constructor.name}: #{objectId}"
        likeAction = true
  
      do object.saveQ
    .then (result) ->
      result[0].likeAction = likeAction
      return result[0]
  
  # create and send notice based on Like's type
  sendLikeNotice : (Model, doc, fromWhom) ->
    targetName = Model.constructor.name
    console.log 'TargetName: ', targetName
    data = {}
    targetUserId = null
    noticeType = null

    switch targetName
      when 'Article', 'Course'
        data.articleId = doc._id
        targetUserId = doc.author
        noticeType = Const.NoticeType["Like#{targetName}"]

      when 'Comment'
        targetUserId = doc.postBy
        if comment.type == Const.CommentType.Article
          noticeType = Const.NoticeType.LikeArticleComment
          data.articleId = doc.belongTo
        else if comment.type == Const.CommentType.Course
          noticeType = Const.NoticeType.LikeCourseComment
          data.courseId = doc.belongTo
        else
          logger.error 'Unknow comment type'
      else
        logger.error 'Unknown Like type'

    NoticeUtils.addNotice targetUserId, fromWhom, noticeType, data
    .then (notice) ->
      console.log 'Notice to send: ', notice
      SocketUtils.sendNotices notice

      # TODO: for mobile app
      #DeviceUtils.pushToUser notice

exports.Instance = new LikeUtils()
exports.Class = LikeUtils