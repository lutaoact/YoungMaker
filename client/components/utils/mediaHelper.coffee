angular.module 'maui.components'

.service 'mediaHelper', ($window) ->
  mediaHelper =
    isMd: ->
      $window.innerWidth >= 1062 and $window.innerWidth < 1360
    isLg: ->
      $window.innerWidth >= 1360
    isSm: ->
      $window.innerWidth >= 768 and $window.innerWidth < 1062
    isXs: ->
      $window.innerWidth < 768
  mediaHelper
