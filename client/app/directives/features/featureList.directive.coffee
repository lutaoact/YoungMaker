'use strict'

angular.module('mauiApp').directive 'featureList', ->
  templateUrl: 'app/directives/features/featureList.html'
  restrict: 'EA'
  replace: true
  scope:
    title: '@'
    offset: '@distance'
  link: (scope, element, attrs) ->
