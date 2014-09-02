'use strict'

angular.module('budweiserApp').controller 'ForumTopicCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $modal
  $sce
  CurrentUser
  focus
  $timeout
  textAngularManager
) ->

  if not $state.params.courseId or not $state.params.topicId
    return

  editorScope = undefined

  angular.extend $scope,
    loading: true

    course: null

    replies: null

    topic: null

    myReply: null

    replying: false

    me: CurrentUser

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course

    loadLectures: ()->
      Restangular.all('lectures').getList({courseId: $state.params.courseId})
      .then (lectures)->
        $scope.course.$lectures = lectures


    loadReplies: ()->
      Restangular.all('dis_replies').getList({disTopicId: $state.params.topicId})
      .then (replies)->
        replies.forEach (reply)->
          reply.$safeContent = $sce.trustAsHtml reply.content
        $scope.replies = replies

    loadTopic: ()->
      Restangular.one('dis_topics', $state.params.topicId).get()
      .then (topic)->
        topic.$safeContent = $sce.trustAsHtml topic.content
        $scope.topic = topic

    initMyReply: ()->
      @myReply = {} if !@myReply
      @myReply.content = ''

    reply: ()->
      # validate

      @replying = true
      @replies.post @myReply, {disTopicId: $state.params.topicId}
      .then (dis_reply)->
        $scope.replies.get(dis_reply._id)
      .then (dis_reply)->
        $scope.replies.push dis_reply
        $scope.initMyReply()
        $scope.replying = false

    toggleVote: (reply)->
      reply.one('vote').post()
      .then (res)->
        reply.voteUpUsers = res.voteUpUsers

  retrieveEditor = ()->
    editorScope = editorScope or textAngularManager.retrieveEditor('replyEditor').scope
    editorScope

  $scope.$watch 'isEditorVisible', (value)->
    if value is true
      retrieveEditor().displayElements.text.trigger('focus');

  $q.all [
    $scope.loadCourse()
    $scope.loadLectures()
    $scope.loadReplies()
    $scope.loadTopic()
  ]
  .then ()->
    $scope.loading = false
    $scope.initMyReply()
