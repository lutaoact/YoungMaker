'use strict'

angular.module('mauiApp').directive 'courseTile', ->
  templateUrl: 'app/course/course-tile/course-tile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->

  controller: ($scope)->
    $scope.stopPropagation = ($event)->
      $event.stopPropagation()
