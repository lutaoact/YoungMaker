Notice = _u.getModel 'notice'

class NoticeUtils
  addNotice: (userId, fromWhom, type, discussionId) ->
    data =
      userId: userId
      fromWhom: fromWhom
      type: type
      data:
        discussionId: discussionId
      status: 0

    Notice.createQ data

  addTopicVoteUpNotice: (userId, fromWhom, disTopicId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicVoteUp, disTopicId

#module.exports = NoticeUtils
exports.NoticeUtils = NoticeUtils
#addNotice = (userId, fromWhom, type, discussionId) ->
#  data =
#    userId: userId
#    fromWhom: fromWhom
#    type: type
#    data:
#      discussionId: discussionId
#    status: 0
#
#  save = Q.nbind Notice.save, Notice
#  save data
#  .then (notice) ->
#    return Q(notice)
#  , (err) ->
#    return Q.reject err

#exports.addLectureNotices = (userIds, lectureIds) ->
#  data =
#    type: Const.NoticeType.Lecture
#    data: {}
#    status: 0
#
#  save = Q.nbind Notice.save, Notice
#  result = []
#  for userId in userIds
#    data.userId = userId
#    for lectureId in lectureIds
#      data.data.lectureId = lectureId
#      result.push save data
#
#  Q.all result
#  .then (datas) ->
#    return Q(datas)
#  , (err) ->
#    return Q.reject err
#
#
#exports.addVoteUpNotice = (userId, fromWhom, discussionId) ->
#  return addNotice userId, fromWhom, Const.NoticeType.VoteUp, discussionId
#
#exports.addCommentNotice = (userId, fromWhom, discussionId) ->
#  return addNotice userId, fromWhom, Const.NoticeType.Comment, discussionId

#### test code for addLectureNotices ####
#userIds = ['111111111111111111111111', '111111111111111111111113', '111111111111111111111112']
#lectureIds = ['222222222222222222222222', '222222222222222222222223', '222222222222222222222222']
#exports.addLectureNotices userIds, lectureIds
#.then (notice) ->
#  console.log notice
#, (err) ->
#  console.log err

#### test code for addCommentNotice and addVoteUpNotice ####
#userId = '53ec4b92c080c9762a2b6b17'
#fromWhom = '322222222222222222222222'
#discussionId = '422222222222222222222222'
#
#exports.addCommentNotice userId, fromWhom, discussionId
#.then (notice) ->
#  console.log notice
#, (err) ->
#  console.log err
#exports.addVoteUpNotice userId, fromWhom, discussionId
#.then (notice) ->
#  console.log notice
#, (err) ->
#  console.log err
