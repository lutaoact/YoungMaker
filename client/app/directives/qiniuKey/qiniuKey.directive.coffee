'use strict'

angular.module('budweiserApp').directive 'qiniuKey', ($http)->
  restrict: 'A'
  scope:{qiniuKey:'='}
  link: ($scope, $element, $attrs) ->
    $scope.$watch 'qiniuKey',(value)->
      if value
        $http.get('api/qiniu/signedUrl/' + encodeURIComponent(value))
        .success (url)->
          $element[0].src = url
