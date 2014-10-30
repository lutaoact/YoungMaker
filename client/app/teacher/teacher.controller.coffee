'use strict'

angular.module('budweiserApp').controller 'TeacherCtrl', (
  $scope
  $state
  webview
) ->

  angular.extend $scope,
    webview: webview
    $state: $state


