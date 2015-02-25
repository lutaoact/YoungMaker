'use strict'

angular.module('maui.components')

.directive 'pen', (configs)->
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
  replace: true
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
      penEl.off 'keyup', extractContent
      penEl.on 'keyup', extractContent
    extractContent = ()->
      ngModel.$setViewValue(penEl.html())
    config = angular.copy(scope.pen ? defaults)
    config.editor = penEl[0]
    pen = new Pen(config)
    scope.$on '$destroy', ->
      pen.destroy()
    scope.$on 'pen.image.uploaded', (event,key)->
      penEl.append("""<p><img src="#{key}"></p>""")
      extractContent()
    scope.$on 'pen.emoji.inserted', (event,emoji)->
      path = "#{configs.cdn}/emojis/#{emoji}.png"
      penEl.append("""<img class="emoji" src="#{path}" alt=":#{emoji}:" height="20" width="20" align="absmiddle" title=":#{emoji}:">""")
      extractContent()

  controller: ($scope, configs) ->
    $scope.emojis = [
      'smile'
      '-1'
      '+1'
      '100'
      '1234'
      'angry'
    ]

    $scope.configs = configs

    $scope.insertEmoji = (emoji)->
      $scope.$broadcast 'pen.emoji.inserted', emoji

    $scope.onImageUploaded = (key)->
      $scope.$broadcast 'pen.image.uploaded', key
