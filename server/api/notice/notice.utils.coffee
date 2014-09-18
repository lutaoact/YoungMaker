Notice = _u.getModel 'notice'

class NoticeUtils
  addNotice: (userId, fromWhom, type, objectId) ->
    data =
      userId: userId
      fromWhom: fromWhom
      type: type
      data: {}
      status: 0

    data.data[Const.NoticeRef[type]] = objectId

    Notice.createQ data

  #fromWhom给userId的disTopicId评论了
  addTopicCommentNotice: (userId, fromWhom, disTopicId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicVoteUp, disTopicId

  #fromWhom给userId的disTopicId点赞了
  addTopicVoteUpNotice: (userId, fromWhom, disTopicId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicVoteUp, disTopicId

  #fromWhom给userId的disReplyId点赞了
  addReplyVoteUpNotice: (userId, fromWhom, disReplyId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.ReplyVoteUp, disReplyId

  buildLectureNotices: (userIds, lectureIds) ->
    datas = []
    for userId in userIds
      datas = datas.concat(
        for lectureId in lectureIds
          userId: userId
          type: Const.NoticeType.Lecture
          status: 0
          data:
            lecture: lectureId
      )
    return datas

  addLectureNotices: (userIds, lectureIds) ->
    datas = @buildLectureNotices userIds, lectureIds
    console.log datas

    Notice.createQ datas

exports.NoticeUtils = NoticeUtils
