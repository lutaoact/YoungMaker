'use strict'

angular.module('mauiApp').directive 'courseTile', ->
  templateUrl: 'app/course/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    me: '='
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

      toggleCollect: ()->
        $scope.course.one('like').post()
        .then (res)->
          $scope.course.likeUsers = res.likeUsers


