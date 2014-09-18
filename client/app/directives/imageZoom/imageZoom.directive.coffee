'use strict'

angular.module('budweiserApp').directive 'imageZoom', (imageZoomViewer)->
  restrict: 'C'
  link: (scope, element, attrs) ->
    element.on 'click', ->
      # get the raw url
      rawSrc = element.attr('src').replace '-blog',''
      imageZoomViewer.open
        rawSrc: rawSrc

.factory 'imageZoomViewer', ($http, $compile, $rootScope)->
  viewer = undefined

  open: (options)->
    if !viewer
      $http.get('app/directives/imageZoom/imageZoomViewer.html')
      .success (template)->
        scope = $rootScope.$new()
        scope.rawSrc = options.rawSrc
        viewer = $compile(template)(scope)
        angular.element('body').append(viewer)
        viewer.on 'click', ->
          viewer.hide()
    else
      viewer.scope().rawSrc = options.rawSrc
      viewer.show()











