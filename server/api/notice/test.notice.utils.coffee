require '../../common/init'

NoticeUtils = _u.getUtils 'notice'
DisTopic = _u.getModel 'dis_topic'

#### test code for addLectureNotices ####
userIds = ['111111111111111111111111', '111111111111111111111113', '111111111111111111111112']
lectureIds = ['222222222222222222222222', '222222222222222222222223', '222222222222222222222222']
NoticeUtils.addLectureNotices userIds, lectureIds
.then (results) ->
  console.log results
, (err) ->
  console.log err

#### test code for addTopicCommentNotice ####
userId = '53ec4b92c080c9762a2b6b17'
fromWhom = '322222222222222222222222'
objectId = '888888888888888888888800'
NoticeUtils.addTopicCommentNotice userId, fromWhom, objectId
.then (result) ->
  console.log result
, (err) ->
  console.log err
