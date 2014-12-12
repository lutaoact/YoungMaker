'use strict'

angular.module('mauiApp').directive 'courseTile', ->
  templateUrl: 'app/course/course-tile/course-tile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth)->
    angular.extend $scope,
      stopPropagation: ($event)->
        $event.stopPropagation()

      toggleVote: ()->
        $scope.course.one('like').post()
        .then (res)->
          $scope.course.likeUsers = res.likeUsers
      getMe: Auth.getCurrentUser

      toggleCollect: ()->
        $scope.course.one('like').post()
        .then (res)->
          $scope.course.likeUsers = res.likeUsers


