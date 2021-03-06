'use strict'

angular.module('mauiApp').directive 'socialShare', ($location) ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/social/socialShare/socialShare.html'

  link: (scope, element, attrs) ->

    getAbsolutePath = (path)->

      if path.startsWith '/'
        document.location.protocol + '//' + document.location.host + path
      else if /^(?:\/|[a-z]+:\/\/)/.test path
        path
      else
        document.location.protocol + '//' + document.location.host + '/' + path

    scope.entity =
      url: $location.$$absUrl
    if attrs.title
      scope.entity.title = attrs.title
    else
      scope.entity.title = document.title
    if attrs.summary
      scope.entity.summary = attrs.summary
    if attrs.image
      scope.entity.image = getAbsolutePath(attrs.image)

    scope.getWeiboShareUrl = (url)->
      if url.indexOf('?') > 0
        url += '&weibo'
      else
        url += '?weibo'
      url
    scope.getQzoneShareUrl = (url)->
      if url.indexOf('?') > 0
        url += '&qzone'
      else
        url += '?qzone'
      url

    attrs.$observe 'title', (value)->
      scope.entity.title = attrs.title

    attrs.$observe 'summary', (value)->
      scope.entity.summary = attrs.summary

    attrs.$observe 'image', (value)->
      scope.entity.image = getAbsolutePath(attrs.image)

