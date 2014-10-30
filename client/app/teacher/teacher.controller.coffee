'use strict'

angular.module('mauiApp').controller 'TeacherCtrl', (
  $scope
  $state
  webview
) ->

  angular.extend $scope,
    webview: webview
    $state: $state


