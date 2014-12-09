'use strict'

angular.module('maui.components')

.directive 'pen', ->
  defaults =
    class: 'pen',
    textarea: '<textarea name="content"></textarea>',
    list: [
      'blockquote', 'h2', 'h3', 'p', 'insertorderedlist', 'insertunorderedlist',
      'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
    ],
    stay: false
  scope:
    pen: '='
  restrict: 'EA'
  require: 'ngModel'
  link: (scope, element, attr, ngModel)->
    ngModel.$render = ()->
      if ngModel.$viewValue
        element.html(ngModel.$viewValue)
      else
        element.html('')
      element.on 'blur', extractContent
    extractContent = ()->
      ngModel.$setViewValue(element.html())
    if scope.pen
      config = angular.copy scope.pen
    else
      config = angular.copy defaults
    config.editor = element[0]
    editor = new Pen(config)
    console.log ngModel

