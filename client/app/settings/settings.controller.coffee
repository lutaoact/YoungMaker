'use strict'

angular.module('mauiApp').controller 'SettingsCtrl', (
  Auth
  $scope
  $location
) ->

  angular.extend $scope,

    menu: [
      {
        title: '我的消息'
        link: 'settings/notice'
      }
    ]

    isActive: (route) ->
      route.split('/').pop() is $location.path().split('/').pop()

