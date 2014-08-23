'use strict'

angular.module('budweiserApp').controller 'SettingsCtrl', ($scope,$location) ->
  angular.extend $scope,
    menu: [
      {
        title: '个人资料'
        link: 'settings/profile'
      }
      {
        title: '账户安全'
        link: 'settings/security'
      }
      {
        title: '支付信息'
        link: 'settings/billing'
      }
    ]

    isActive: (route) ->
      _.str.trim(route, '/') is _.str.trim($location.path(), '/')


