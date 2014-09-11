'use strict'

angular.module('budweiserApp').directive 'timetable', ->
  templateUrl: 'app/directives/timetable/timetable.html'
  restrict: 'E'
  scope:
    eventSouces: '='
    eventClick: '&'
  controller: ($scope)->
    angular.extend $scope,
      onEventClick: ($event, event)->
        eventClick() event
      today: moment()
  link: (scope, element, attrs) ->
