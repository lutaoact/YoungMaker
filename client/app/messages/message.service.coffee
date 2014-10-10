angular.module 'budweiserApp'
.factory 'Msg', (Restangular, $q, $localStorage, Auth)->
  genMessage = (raw)->
    deferred = $q.defer()
    switch raw.type
      when Const.NoticeType.TopicVoteUp
        deferred.resolve
          title: '赞了你的帖子：' + raw.data.disTopic.title
          raw: raw
          link: "forum.topic({courseId:'#{raw.data.disTopic.courseId}',topicId:'#{raw.data.disTopic._id}'})"
          type: 'message'
      when Const.NoticeType.ReplyVoteUp
        Restangular.one('dis_topics', raw.data.disReply.disTopicId).get()
        .then (topic)->
          raw.data.disTopic = topic
          deferred.resolve
            title: '赞了你的回复：' + raw.data.disReply.content
            raw: raw
            link: "forum.topic({courseId:'#{topic.courseId}',topicId:'#{raw.data.disReply.disTopicId}',replyId:'#{raw.data.disReply._id}'})"
            type: 'message'
      when Const.NoticeType.Comment
        Restangular.one('dis_topics', raw.data.disReply.disTopicId).get()
        .then (topic)->
          console.log raw
          raw.data.disTopic = topic
          deferred.resolve
            title: '回复了你的帖子：' + raw.data.disTopic.title
            raw: raw
            link: "forum.topic({courseId:'#{topic.courseId}',topicId:'#{raw.data.disReply.disTopicId}',replyId:'#{raw.data.disReply._id}'})"
            type: 'message'

      else deferred.reject()
    deferred.promise

  instance =
    messages: []
    genMessage: genMessage
    init: ()->
      Restangular.all('notices').getList()
      .then (notices)->
        notices.forEach (notice)->
          genMessage(notice).then (msg)->
            instance.messages.splice 0, 0, msg

  return instance

