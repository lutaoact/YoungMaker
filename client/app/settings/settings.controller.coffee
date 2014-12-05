'use strict'

angular.module('mauiApp').controller 'SettingsCtrl', (
  Auth
  $scope
  webview
  $location
) ->

  angular.extend $scope,
    webview: webview
    me: null

    menu: [
      {
        title: '基本信息'
        link: 'settings/profile'
      }
    ]

    isActive: (route) ->
      _.str.trim(route, '/') is _.str.trim($location.path(), '/')

  Auth.getCurrentUser().$promise
  .then (me) ->
    $scope.me = me

