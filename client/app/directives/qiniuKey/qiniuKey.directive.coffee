'use strict'

angular.module('budweiserApp').directive 'qiniuKey', ($http)->
  restrict: 'A'
  scope:
    qiniuKey:'='
    qiniuConf:'@'
    sourceAttr:'@'
    suffix:'@'

  link: ($scope, $element, $attrs) ->
    setSource = (url)->
      switch $scope.sourceAttr
        when 'background-image'
          $element.css('background-image','url(' + url + ')')
        when 'data'
          $element[0].data = url
        else
          $element[0].src = url

    $scope.$watch 'qiniuKey',(key) ->
      if !key || /\/\//.test(key)
        setSource(key)
      else
        query = if $attrs.qiniuConf? then '?' + $attrs.qiniuConf else  ''
        suffix = $scope.suffix ? ''
        $http.get('/api/qiniu/signed_url/' + encodeURIComponent(key + query + suffix))
        .success setSource

