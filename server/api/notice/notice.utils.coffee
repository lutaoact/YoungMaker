Notice = _u.getModel 'notice'

class NoticeUtils
  addNotice: (userId, fromWhom, type, objectId) ->
    data =
      userId: userId
      fromWhom: fromWhom
      type: type
      data: {}
      status: 0

    ref = Const.NoticeRef[type]
    data.data[ref] = objectId

    Notice.createQ data
    .then (notice) ->
      notice.populateQ "data.#{ref} fromWhom"

  #fromWhom给userId的disTopicId评论了
  addTopicCommentNotice: (userId, fromWhom, disTopicId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicVoteUp, disTopicId

  #fromWhom给userId的disTopicId点赞了
  addTopicVoteUpNotice: (userId, fromWhom, disTopicId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicVoteUp, disTopicId

  #fromWhom给userId的disReplyId点赞了
  addReplyVoteUpNotice: (userId, fromWhom, disReplyId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.ReplyVoteUp, disReplyId

  #userId，有新的lecture发布了哦，赶紧去看吧
  buildLectureNotices: (userIds, lectureId) ->
    return (for userId in userIds
      userId: userId
      type: Const.NoticeType.Lecture
      status: 0
      data:
        lecture: lectureId
    )

  addLectureNotices: (userIds, lectureId) ->
    datas = @buildLectureNotices userIds, lectureId

    Notice.createQ datas

exports.NoticeUtils = NoticeUtils
