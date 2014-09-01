'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    course: null

    discussions: null

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

  $q.all [
    $scope.loadCourse()
    $scope.loadLectures()
    $scope.loadDiscussions()
  ]
  .then ()->
    $scope.loading = false


