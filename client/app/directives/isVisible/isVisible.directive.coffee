'use strict'

# currently used in topic detail view. When I click comment button, the page
# scrolls to bottom. And it should tell the editor is visible
angular.module('budweiserApp').directive 'isVisible', ($document, $timeout, $window)->
  restrict: 'A'
  scope:
    isVisible: '='
    adjustOffsetTop:'@'
    adjustOffsetBottom:'@'
  link: (scope, $element)->
    clear = () ->
      # unbind event handle
      scrollParent.off 'scroll',scrollHandle

    topOffset = 0
    bottomOffset = 0
    if scope.adjustOffsetTop
      topOffset = scope.adjustOffsetTop
    if scope.adjustOffsetBottom
      bottomOffset = scope.adjustOffsetBottom
    scrollHandle = ()->
      elemTop = $element[0].getBoundingClientRect().top
      $timeout () ->
        scope.isVisible = elemTop < $window.innerHeight + topOffset && (bottomOffset - elemTop) < 0

    # Find element's parent, bind scroll event
    scrollParent = $element.scrollParent?() or $document
    scrollParent.on 'scroll', scrollHandle

    scope.$on('$destroy', clear)
