'use strict'

angular.module('budweiserApp').directive 'timetable', ->
  templateUrl: 'app/directives/timetable/timetable.html'
  restrict: 'E'
  scope:
    eventSouces: '='
    eventClick: '&'
  controller: ($scope)->
    $scope.onEventClick = ($event, event)->
      $scope.eventClick() event

  link: (scope, element, attrs) ->
