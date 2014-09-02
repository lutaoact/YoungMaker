'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.home',
    url: ''
    templateUrl: 'app/forum/forumHome/forumHome.html'
    controller: 'ForumHomeCtrl'
