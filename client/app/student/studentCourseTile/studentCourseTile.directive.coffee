'use strict'

angular.module('budweiserApp').directive 'studentCourseTile', ->
  templateUrl: 'app/student/studentCourseTile/studentCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
