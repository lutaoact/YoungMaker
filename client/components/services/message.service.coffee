angular.module 'maui.components'

.factory 'Msg', (Restangular)->

  genMessage = (raw)->
    msg =
      raw: raw
      type: 'message'

    switch raw.type
      when Const.NoticeType.ArticleComment
        msg.title = '回复了你的文章：' + raw.data.articleId.title
        msg.link = "articleDetail({articleId:'#{raw.data.articleId._id}'})"
      when Const.NoticeType.LikeArticleComment
        msg.title = '赞了你的回复：' + raw.data.articleId.title
        msg.link = "articleDetail({articleId:'#{raw.data.articleId._id}'})"
      when Const.NoticeType.CourseComment
        msg.title = '回复了你的趣课：' + raw.data.courseId.title
        msg.link = "courseDetail({courseId:'#{raw.data.courseId._id}'})"
      when Const.NoticeType.LikeCourse
        msg.title = '赞了你的趣课：' + raw.data.courseId.title
        msg.link = "courseDetail({courseId:'#{raw.data.courseId._id}'})"
      when Const.NoticeType.LikeCourseComment
        msg.title = '赞了你的回复：' + raw.data.courseId.title
        msg.link = "courseDetail({courseId:'#{raw.data.courseId._id}'})"
      when Const.NoticeType.FollowUser
        msg.title = '关注了你'
        msg.link = "user.home({userId:'#{raw.fromWhom._id}'})"

    return msg

  instance =
    unreadMsgCount: 0
    genMessage: genMessage
    init: ()->
      Restangular.all('notices').customGET('unreadCount')
      .then (data)->
        instance.unreadMsgCount = data.unreadCount
    addMsg: ->
      instance.unreadMsgCount += 1
    readMsg: ->
      instance.unreadMsgCount -= 1 if instance.unreadMsgCount > 0
    clearMsg: ->
      instance.unreadMsgCount = 0
    getMsgCount: ->
      instance.unreadMsgCount

  return instance

