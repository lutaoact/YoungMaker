'use strict'

angular.module('mauiApp').controller 'AdminCtrl', (
  $scope
  webview
) ->

  angular.extend $scope,
    webview: webview

