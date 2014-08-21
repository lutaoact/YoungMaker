'use strict'

angular.module('budweiserApp').directive 'disableAnimation', ($animate)->
  restrict: 'A'
  link: (scope, element, attrs) ->
    attrs.$observe 'disableAnimation', (value)->
      $animate.enabled !value, element
