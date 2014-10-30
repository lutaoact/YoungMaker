'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.course',
    url: '/courses/:courseId'
    templateUrl: 'app/forum/forumCourse/forumCourse.html'
    controller: 'ForumCourseCtrl'
    authenticate: true

