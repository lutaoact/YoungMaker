'use strict'

angular.module('budweiserApp')

.directive 'clickOutside', ($document, $timeout) ->
  restrict: 'A'
  scope:
    isActive: '='
    clickOutside: '&'
  link: (scope, element) ->

    doChange = (event) ->
      inslideElement = element.find(event.target).length > 0
      $timeout scope.clickOutside if !inslideElement

    scope.$watch 'isActive', (newValue) ->
      if newValue
        $document.bind 'click', doChange
      else
        $document.unbind 'click', doChange


