angular.module 'maui.components'

.directive 'backButton', ($window) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.css('display', 'none') if !($window.history.length > 1)
    elem.on 'click', (event) ->
      $window.history.back()
