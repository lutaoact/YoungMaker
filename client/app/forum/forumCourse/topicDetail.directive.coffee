'use strict'

angular.module('budweiserApp')

.directive 'topicDetail', ->
  restrict: 'E'
  replace: true
  controller: 'TopicDetailCtrl'
  templateUrl: 'app/forum/forumCourse/topicDetail.template.html'
  scope:
    topic: '='

.controller 'TopicDetailCtrl', ($scope, Auth, Restangular, $timeout, $document, $state)->
  angular.extend $scope,

    me: Auth.getCurrentUser()

    newReply: {}
    replying: false

    replyTo: (topic, reply)->
      # validate
      @replying = true
      topic.$replies.post reply, {disTopicId: topic._id}
      .then (dis_reply)->
        topic.$replies.splice 0, 0, dis_reply
        $scope.initMyReply()
        $scope.replying = false

    initMyReply: ()->
      @newReply = {} if !@newReply
      @newReply.content = ''
      @newReply.metadata = {}

    toggleLike: (topic)->
      topic.one('vote').post()
      .then (res)->
        topic.voteUpUsers = res.voteUpUsers

    toggleVote: (reply)->
      reply.one('vote').post()
      .then (res)->
        reply.voteUpUsers = res.voteUpUsers

    deleteReply: (topic, reply)->
      reply.remove()
      .then ()->
        topic.$replies.splice topic.$replies.indexOf(reply), 1

    scrollToEditor: ()->
      $document.scrollToElement(angular.element('.new-reply-right'), 200, 200)







