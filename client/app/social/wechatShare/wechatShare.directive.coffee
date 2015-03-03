'use strict'

angular.module('mauiApp').directive 'wechatShare', ($modal, $location) ->
  restrict: 'EA'
  link: (scope, element)->
    element.bind 'click', ()->
      url = $location.$$absUrl
      if url.indexOf('?') > 0
        url += '&wechat'
      else
        url += '?wechat'
      $modal.open
        templateUrl: 'app/social/wechatShare/wechatShareModal.html'
        size: 'sm'
        resolve:
          url: -> url
        controller: ($scope, url, $modalInstance)->
          $scope.url = url
          $scope.close = ()->
            $modalInstance.dismiss('cancel')


