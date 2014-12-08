'use strict'

angular.module('maui.components')

.directive 'retinaKey', ($window)->
  isRetina = () ->
    mediaQuery = "(-webkit-min-device-pixel-ratio: 1.5), (min--moz-device-pixel-ratio: 1.5), " +
      "(-o-min-device-pixel-ratio: 3/2), (min-resolution: 1.5dppx)"
    if $window.devicePixelRatio > 1
      true
    $window.matchMedia && $window.matchMedia(mediaQuery).matches

  restrict: 'A'
  link: (scope, element, attrs) ->
    attrs.$observe 'retinaKey', (value) ->
      if !value
        return
      if isRetina()
        element.attr('src',value)
      else
        return


