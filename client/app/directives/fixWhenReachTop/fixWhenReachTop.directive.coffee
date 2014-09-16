'use strict'

angular.module('budweiserApp').directive 'fixWhenReachTop', ($timeout, $window, $document)->
  restrict: 'A'
  scope:
    offset: '@'
    fixedClass: '@'
  link: (scope, element, attrs) ->
    $timeout ->
      scope.offset ?= 0
      scope.fixedClass ?= 'fixed'

      clear = () ->
        # unbind event handle
        scrollParent.off 'scroll',scrollHandle

      scrollHandle = ()->
        scrollTop = window.pageYOffset or $document.scrollTop()
        if scrollTop > scope.offset
          element.addClass scope.fixedClass
        else
          element.removeClass scope.fixedClass

      # Find element's parent, bind scroll event
      scrollParent = $document
      scrollParent.on 'scroll', scrollHandle
      $document.on 'resize', scrollHandle
      # should happen at leat once
      scrollHandle.apply(scrollParent)

      scope.$on('$destroy', clear)



