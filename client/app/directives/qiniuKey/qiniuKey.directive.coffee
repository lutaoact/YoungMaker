'use strict'

angular.module('budweiserApp').directive 'qiniuKey', ($http, $q)->
  restrict: 'A'
  scope:{qiniuKey:'=',sourceAttr:'@',suffix:'@'}
  link: ($scope, $element, $attrs) ->
    $scope.$watch 'qiniuKey',(value)->
      deferred = $q.defer()
      if value
        $http.get('/api/qiniu/signedUrl/' + encodeURIComponent(value + if $scope.suffix then $scope.suffix else ''))
        .success (url)->
          deferred.resolve url
      else
        deferred.resolve

      setSrc = (url)->
        if url
          $element[0].src = url

      deferred.promise.then (url)->
        switch true
          when $scope.sourceAttr is undefined or $scope.sourceAttr is '' or $scope.sourceAttr is 'src'
            setSrc(url)
          when $scope.sourceAttr is 'background-image'
            $element.css('background-image','url(' + url + ')')
          when $scope.sourceAttr is 'data'
            $element[0].data = url
