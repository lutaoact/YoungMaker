'use strict'

angular.module('budweiserApp').controller 'ForumDiscussionCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
) ->

  if not $state.params.courseId or not $state.params.discussionId
    return
  angular.extend $scope,
    loading: true

    course: null

    discussions: null

    discussion: null

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course

    loadLectures: ()->
      Restangular.all('lectures').getList({courseId: $state.params.courseId})
      .then (lectures)->
        $scope.course.$lectures = lectures


    loadDiscussions: ()->
      Restangular.all('discussions').getList({courseId: $state.params.courseId})
      .then (discussions)->
        $scope.discussions = discussions
        $scope.discussions.forEach (discussion)->
          discussion.postBy.avatar = 'http://lorempixel.com/128/128/people/?id=' + discussion._id

    loadDiscussion: ()->
      Restangular.one('discussions', $state.params.discussionId).get()
      .then (discussion)->
        $scope.discussion = discussion
        discussion.postBy.avatar = 'http://lorempixel.com/128/128/people/?id=' + discussion._id

  $q.all [
    $scope.loadCourse()
    $scope.loadLectures()
    $scope.loadDiscussions()
    $scope.loadDiscussion()
  ]
  .then ()->
    $scope.loading = false
