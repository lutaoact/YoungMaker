BaseUtils = require '../../common/BaseUtils'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'
Course = _u.getModel 'course'

buildLikeCommentArgs = (comment) ->
  
  result = 
    data :
      commentId : comment._id
  
  Q(switch comment.type
      when Const.CommentType.Topic
        result.noticeType = Const.NoticeType.LikeTopicComment
        result.data.topicId = comment.belongTo
        Topic.findByIdQ result.data.topicId
        .then (topic)->
          result.data.forumId = topic.forumId

      when Const.CommentType.Course
        result.noticeType = Const.NoticeType.LikeCourseComment
        result.data.courseId = comment.belongTo
        result.data.classeId = comment.extra?.classeId

      when Const.CommentType.Lecture
        result.noticeType = Const.NoticeType.LikeLectureComment
        result.data.lectureId = comment.belongTo
        Course.getByLectureId result.data.lectureId
        .then (course)->
          result.data.courseId = course._id
          result.data.classeId = comment.extra?.classeId

      when Const.CommentType.Teacher
        console.log 'like comment for teacher...'
        #TODO: add like the comment for teacher
  ).then ->
    return result
  
  
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
    
    Q(switch targetName
        when 'Topic'
          data.topicId = doc._id
          data.forumId = doc.forumId
          targetUserId = doc.postBy
          noticeType = Const.NoticeType.LikeTopic

        when 'Comment'
          targetUserId = doc.postBy
          buildLikeCommentArgs doc
          .then (commentArgs)->
            {noticeType, data} = commentArgs
        else
          logger.error 'Unknown Like type'
    )
    .then ->
      NoticeUtils.addNotice targetUserId, fromWhom, noticeType, data
    .then (notice) ->
      console.log 'Notice to send: ', notice
      SocketUtils.sendNotices notice

      # TODO: for mobile app
      #DeviceUtils.pushToUser notice

exports.LikeUtils = LikeUtils
