'use strict'

angular.module('budweiserApp').directive 'featureList', ->
  templateUrl: 'app/directives/features/featureList.html'
  restrict: 'EA'
  replace: true
  scope:
    title: '@'
  link: (scope, element, attrs) ->
