'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.topic',
    url: '/courses/:courseId/topics/:topicId?replyId'
    templateUrl: 'app/forum/forumTopic/forumTopic.html'
    controller: 'ForumTopicCtrl'
    authenticate: true
