'use strict'

# currently used in topic detail view. When I click comment button, the page
# scrolls to bottom. And it should tell the editor is visible
angular.module('mauiApp').directive 'isVisible', ($document, $timeout, $window)->
  restrict: 'A'
  scope:
    isVisible: '='
    adjustOffsetTop:'@'
    adjustOffsetBottom:'@'
  link: (scope, $element)->
    clear = () ->
      # unbind event handle
      scrollParent.off 'scroll',scrollHandle
      scrollParent.off 'resize', scrollHandle

    topOffset = 0
    bottomOffset = 0
    lastState = undefined
    if scope.adjustOffsetTop
      topOffset = scope.adjustOffsetTop
    if scope.adjustOffsetBottom
      bottomOffset = scope.adjustOffsetBottom
    scrollHandle = (e)->
      elemTop = $element[0].getBoundingClientRect().top
      $timeout () ->
        currentState = elemTop < $window.innerHeight + topOffset && (bottomOffset - elemTop) < 0
        if currentState isnt lastState
          lastState = currentState
          scope.isVisible = lastState

    # Find element's parent, bind scroll event
    scrollParent = $element.scrollParent?() or $document
    scrollParent.on 'scroll', scrollHandle
    scrollParent.on 'resize', scrollHandle

    # should happen at least once
    $timeout ->
      scrollHandle.apply scrollParent
    , 200

    scope.$on('$destroy', clear)
