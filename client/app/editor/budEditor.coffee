'use strict'

angular.module('budweiserApp').directive 'budEditor', ()->
  restrict: 'E'
  scope:
    metadata: '='
    content: '='
  replace: true
  templateUrl: 'app/editor/bud-editor.html'

  link: (scope, element, attrs) ->

  controller: ($scope,$timeout)->
    angular.extend $scope,
      onImgUploaded: (key)->
        $scope.metadata.images ?= []
        $scope.metadata.images.push
          url: "/api/assets/images/#{key}-blog"
          key: key

      viewstate:
        editorActive: false

      setInactiveHandle: undefined

      setEditorInactive: ()->
        if $scope.setInactiveHandle
          $timeout.cancel $scope.setInactiveHandle
          $scope.setInactiveHandle = undefined
        $scope.setInactiveHandle = $timeout ->
          $scope.viewstate.editorActive = false
          $scope.setInactiveHandle = undefined
        , 200

      setEditorActive: ()->
        if $scope.setInactiveHandle
          $timeout.cancel $scope.setInactiveHandle
          $scope.setInactiveHandle = undefined
        $scope.viewstate.editorActive = true

      removeImg: (image)->
        $scope.metadata.images.splice $scope.metadata.images.indexOf(image), 1

    $scope.$watch 'metadata', (value)->
      # should delay 2 seconds
      $scope.metadata ?= {}
      $scope.metadata.raw ?= ''
      $scope.content = $scope.metadata.raw.replace /\r?\n/g, '<br/>'
      if $scope.metadata.tags
        $scope.content = '<br/>' + $scope.content
      $scope.metadata.tags?.forEach (tag)->
        $scope.content = "<div class=\"tag\" href=\"#{tag.type}\" src=\"#{tag.srcId}\">#{tag.name}</div>"  + $scope.content
      $scope.metadata.images?.forEach (image)->
        $scope.content += "<img class=\"sm image-zoom\" src=\"#{image.url}\">"
    ,true

    $scope.$on '$destroy', ->
      if $scope.setInactiveHandle
        $timeout.cancel $scope.setInactiveHandle
