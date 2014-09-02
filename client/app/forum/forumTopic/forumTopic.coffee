'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.topic',
    url: '/courses/:courseId/topics/:topicId'
    templateUrl: 'app/forum/forumTopic/forumTopic.html'
    controller: 'ForumTopicCtrl'
