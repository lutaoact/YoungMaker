'use strict'

angular.module('mauiApp').controller 'ForumCtrl', (
  $scope
  webview
) ->
  angular.extend $scope,
    webview: webview
