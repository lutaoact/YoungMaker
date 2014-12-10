'use strict'

angular.module('maui.components')

.directive 'pen', ->
  defaults =
    class: 'pen',
    textarea: '<textarea name="content"></textarea>',
    list: [
      'blockquote','pre', 'h3', 'p', 'insertorderedlist', 'insertunorderedlist',
      'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
    ],
    stay: false
  scope:
    pen: '='
    placeholder: '@'
  replace: false
  templateUrl: 'components/directives/pen/pen.html'
  restrict: 'EA'
  require: 'ngModel'
  link: (scope, element, attr, ngModel)->
    penEl = element.find('.pen')
    ngModel.$render = ()->
      if ngModel.$viewValue
        penEl.html(ngModel.$viewValue)
      else
        penEl.html('')
      penEl.on 'blur', extractContent
    extractContent = ()->
      ngModel.$setViewValue(penEl.html())
    if scope.pen
      config = angular.copy scope.pen
    else
      config = angular.copy defaults
    config.editor = penEl[0]
    pen = new Pen(config)
    scope.$on '$destroy', ->
      pen.destroy()
    scope.$on 'pen.image.uploaded', (event,key)->
      penEl.append("<p><img src=\"#{key}\"></p>")
      extractContent()

  controller: ($scope) ->
    $scope.onImageUploaded = (key)->
      $scope.$broadcast 'pen.image.uploaded', key
