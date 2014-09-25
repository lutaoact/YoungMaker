require '../../common/init'

NoticeUtils = _u.getUtils 'notice'
DisTopic = _u.getModel 'dis_topic'
DisReply = _u.getModel 'dis_reply'

#### test code for addLectureNotices ####
userIds = ['111111111111111111111105', '111111111111111111111104', '111111111111111111111103']
lectureId = ['555555555555555555555500']
NoticeUtils.addLectureNotices userIds, lectureId
.then (results) ->
  console.log results
, (err) ->
  console.log err

#### test code for addTopicCommentNotice ####
userId = '111111111111111111111103'
fromWhom = '322222222222222222222222'
topicId = '888888888888888888888800'
replyId = '999999999999999999999900'

NoticeUtils.addTopicCommentNotice userId, fromWhom, topicId
.then (result) ->
  console.log result
, (err) ->
  console.log err

NoticeUtils.addTopicVoteUpNotice userId, fromWhom, topicId
.then (result) ->
  console.log result
, (err) ->
  console.log err

NoticeUtils.addReplyVoteUpNotice userId, fromWhom, replyId
.then (result) ->
  console.log result
, (err) ->
  console.log err
