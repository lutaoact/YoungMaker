'use strict'

angular.module('maui.components')

.directive 'whr', ($window)->

  restrict: 'A'
  link: (scope, element, attrs) ->
    attrs.$observe 'whr', (value) ->
      if value
        resizeHandle = ->
          element.css 'height', element[0].clientWidth / value
        resizeHandle()
        $(window).unbind 'resize', resizeHandle
        $(window).bind 'resize', resizeHandle
        scope.$on '$destroy', ->
          $(window).unbind 'resize', resizeHandle
      else
        $(window).unbind 'resize', resizeHandle




