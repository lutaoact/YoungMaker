'use strict'

angular.module('mauiApp').directive 'socialShare', ($location) ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/social/socialShare/socialShare.html'

  link: (scope, element, attrs) ->
    scope.entity =
      url: $location.$$absUrl
    if attrs.title
      scope.entity.title = attrs.title
    else
      scope.entity.title = document.title
    if attrs.image
      scope.entity.image = attrs.image
    scope.getWeiboShareUrl = (url)->
      if url.indexOf('?') > 0
        url += '&weibo'
      else
        url += '?weibo'
      url

    attrs.$observe 'title', (value)->
      scope.entity.title = attrs.title

    attrs.$observe 'image', (value)->
      scope.entity.image = attrs.image

