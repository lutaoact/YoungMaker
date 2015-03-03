angular.module 'maui.components'

.directive 'backToTop', ->

  restrict: 'EA'

  templateUrl: 'components/directives/backToTop/backToTop.html'

  controller: ($scope, $document, $timeout)->
    $scope.viewState = {}
    $scope.viewState.showBackToTop = false
    $scope.toTop = ()->

    clear = () ->
        # unbind event handle
        $document.off 'scroll',scrollHandle
    scrollHandle = ()->
      scrollTop = window.pageYOffset or $document.scrollTop()
      if scrollTop > 50 and !$scope.viewState.showBackToTop
        $timeout ->
          $scope.viewState.showBackToTop = true
      else if scrollTop <= 50 and $scope.viewState.showBackToTop
        $timeout ->
          $scope.viewState.showBackToTop = false

    # Find element's parent, bind scroll event
    $document.on 'scroll', scrollHandle
    $document.on 'resize', scrollHandle
    # should happen at leat once
    scrollHandle.apply($document)

    $scope.$on('$destroy', clear)


