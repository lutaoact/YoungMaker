'use strict'

angular.module('budweiserApp').directive 'srcKey', ($http)->
  restrict: 'A'
  scope:
    srcKey:'='
    suffix:'@'
    sourceAttr:'@'

  link: ($scope, $element, $attrs) ->
    setSource = (url)->
      switch $scope.sourceAttr
        when 'background-image'
          $element.css('background-image','url(\'' + url + '\')')
        when 'data'
          $element[0].data = url
        else
          $element[0].src = url

    utf8_to_b64 = (str) ->
      btoa(unescape(encodeURIComponent( str )))

    $scope.$watch 'srcKey',(key) ->
      if !key or key is ''
        return
      else if /^(\/\/|\/|http:|https:)/.test(key)
        setSource(key)
      else if $scope.sourceAttr is 'video'
        src = '/api/assets/videos/'+ key
        setSource(src)
      else
        suffix = $scope.suffix ? ''
        src = '/api/assets/images/'+ key + suffix
        # $http.get src
        # .success (data, status, header, a)->
        #   b64 = utf8_to_b64(data)
        #   setSource('data:'+header('content-type')+';base64,' + b64)
        setSource(src)

