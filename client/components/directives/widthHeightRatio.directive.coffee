'use strict'

angular.module('maui.components')

.directive 'whr', ($window)->

  restrict: 'A'
  link: (scope, element, attrs) ->
    attrs.$observe 'whr', (value) ->
      if value
        resizeHandle = ->
          element.css 'height', element[0].clientWidth / value
          if attrs.threshold
            scope[attrs.threshold]?(element[0].clientWidth)
        resizeHandle()
        $(window).unbind 'resize', resizeHandle
        $(window).bind 'resize', resizeHandle
        scope.$on '$destroy', ->
          $(window).unbind 'resize', resizeHandle
      else
        $(window).unbind 'resize', resizeHandle

.directive 'hwr', ($window)->

  restrict: 'A'
  link: (scope, element, attrs) ->
    attrs.$observe 'hwr', (value) ->
      if value
        resizeHandle = ->
          element.css 'width', element[0].clientHeight / value
        resizeHandle()
        $(window).unbind 'resize', resizeHandle
        $(window).bind 'resize', resizeHandle
        scope.$on '$destroy', ->
          $(window).unbind 'resize', resizeHandle
      else
        $(window).unbind 'resize', resizeHandle



