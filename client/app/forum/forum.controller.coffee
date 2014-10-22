'use strict'

angular.module('budweiserApp').controller 'ForumCtrl', (
  $scope
  webview
) ->
  angular.extend $scope,
    webview: webview
