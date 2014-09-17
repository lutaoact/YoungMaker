'use strict'

angular.module('budweiserApp').directive 'fixWhenReachTop', ($timeout, $window, $document)->
  restrict: 'A'
  link: (scope, element, attrs) ->
    $timeout ->
      clear = () ->
        # unbind event handle
        scrollParent.off 'scroll',scrollHandle
      scrollHandle = ()->
        scrollTop = window.pageYOffset or $document.scrollTop()
        if scrollTop > parseInt(attrs.offset)
          element.addClass (attrs.fixedClass or 'fixed')
        else
          element.removeClass (attrs.fixedClass or 'fixed')
      # Find element's parent, bind scroll event
      scrollParent = $document
      scrollParent.on 'scroll', scrollHandle
      $document.on 'resize', scrollHandle
      # should happen at leat once
      scrollHandle.apply(scrollParent)

      scope.$on('$destroy', clear)



