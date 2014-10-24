'use strict'

angular.module('budweiserApp').controller 'SettingsCtrl', (
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
#     暂时不用
#      {
#        title: '支付信息'
#        link: 'settings/billing'
#      }
    ]

    isActive: (route) ->
      _.str.trim(route, '/') is _.str.trim($location.path(), '/')

  Auth.getCurrentUser().$promise
  .then (me) ->
    $scope.me = me

