angular.module('budweiserApp')

.directive 'focusMe', ($timeout) ->
  scope:
    trigger: '=focusMe'
  link: (scope, elem) ->
    scope.$watch 'trigger', (val) -> $timeout ->
      if !val then return
      elem[0].focus()
      elem[0].select()
      scope.trigger = false

.directive 'focusOn', ($timeout) ->
  (scope, elem, attr) ->
    scope.$on 'focusOn', (e, name) -> $timeout ->
      elem[0].focus() if name is attr.focusOn

.factory 'focus', ($rootScope, $timeout) ->
  (name) -> $timeout ->
    $rootScope.$broadcast('focusOn', name) if name?.length > 0
