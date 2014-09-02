'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.discussion',
    url: '/courses/:courseId/discussions/:discussionId'
    templateUrl: 'app/forum/forumDiscussion/forumDiscussion.html'
    controller: 'ForumDiscussionCtrl'
