angular.module('maui.components')

.directive 'focusMe', ($timeout) ->
  scope:
    focusMe: '='
  link: pre: (scope, elem, attrs) ->
    setFocus = -> $timeout ->
      elem[0].focus?()
      elem[0].select?()
    , 100
    if attrs.focusMe is ''
      setFocus()
    else
      scope.$watch 'focusMe', (val) ->
        if !val then return
        setFocus()
        scope.focusMe = false

.directive 'focusOn', ($timeout) ->
  (scope, elem, attr) ->
    scope.$on 'focusOn', (e, name) -> $timeout ->
      elem[0].focus() if name is attr.focusOn

.factory 'focus', ($rootScope, $timeout) ->
  (name) -> $timeout ->
    $rootScope.$broadcast('focusOn', name) if name?.length > 0
