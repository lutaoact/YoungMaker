'use strict'

angular.module('maui.components').directive 'disableAnimation', ($animate)->
  restrict: 'A'
  link: (scope, element) ->
    $animate.enabled false, element
