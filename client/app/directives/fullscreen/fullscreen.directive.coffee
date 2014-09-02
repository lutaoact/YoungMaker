'use strict'

angular.module('budweiserApp').directive 'fullScreen', ($window) ->
  restrict: 'A'
  scope: true
  link:($scope,$element, $attrs) ->
    $scope.initializeWindowSize = ->
      $element.css('width', $window.innerWidth)
      $element.css('height', $window.innerHeight - ($attrs.offsetY or 0))

    $scope.initializeWindowSize()

    angular.element($window).bind 'resize', ->
      $scope.initializeWindowSize()

    $scope.$on '$destroy', () ->
      console.log 'unbind'
      angular.element($window).unbind 'resize', ->
      $scope.initializeWindowSize()
