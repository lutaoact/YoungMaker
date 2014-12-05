'use strict'

angular.module('maui.components')

.directive 'imageZoom', (imageZoomViewer)->
  restrict: 'C'
  link: (scope, element, attrs) ->
    element.on 'click', ->
      # get the raw url
      rawSrc = element.attr('src').replace '-blog',''
      imageZoomViewer.open
        rawSrc: rawSrc

.factory 'imageZoomViewer', ($http, $compile, $rootScope, $timeout)->
  viewer = undefined
  template: '<div class="image-zoom-viewer"><div class="viewer" src-key="rawSrc" source-attr="background-image"></div></div>'
  open: (options)->
    if !viewer
      scope = $rootScope.$new()
      scope.rawSrc = options.rawSrc
      viewer = $compile(@template)(scope)
      angular.element('body').append(viewer)
      angular.element('body').addClass('image-zoom-open')
      viewer.on 'click', ->
        viewer.hide()
        angular.element('body').removeClass('image-zoom-open')
      scope.$on '$stateChangeSuccess', ->
        viewer.hide()
        angular.element('body').removeClass('image-zoom-open')

    else
      viewer.scope().rawSrc = options.rawSrc
      $timeout ->
        viewer.show()
        angular.element('body').addClass('image-zoom-open')












