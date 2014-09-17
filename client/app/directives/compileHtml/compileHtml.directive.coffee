'use strict'

angular.module('budweiserApp').directive 'compileHtml', ($timeout, $compile)->
  restrict: 'A'
  link: (scope, element, attrs) ->
    $timeout ->
      element.on 'load', (event)->
        console.log event
      console.log element.html()

