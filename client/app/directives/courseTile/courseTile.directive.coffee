'use strict'

angular.module('mauiApp').directive 'courseTile', ->
  templateUrl: 'app/directives/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
