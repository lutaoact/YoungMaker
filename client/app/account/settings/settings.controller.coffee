'use strict'

angular.module('budweiserApp').controller 'SettingsCtrl', ($scope, $location, Restangular) ->
  angular.extend $scope,
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

    me: null

    oldMe: null

    getMyProfile: ()->
      Restangular.one('users','me').get()
      .then (user)->
        $scope.me = user
        $scope.oldMe = Restangular.copy(user)

  $scope.getMyProfile()

