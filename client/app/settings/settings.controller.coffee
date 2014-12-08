'use strict'

angular.module('mauiApp').controller 'SettingsCtrl', (
  Auth
  $scope
  webview
  $location
) ->

  angular.extend $scope,
    webview: webview
    me: Auth.getCurrentUser()

    isActive: (route) ->
      _.str.trim(route, '/') is _.str.trim($location.path(), '/')

