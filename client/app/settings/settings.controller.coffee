'use strict'

angular.module('mauiApp').controller 'SettingsCtrl', (
  Auth
  $scope
  $location
) ->

  angular.extend $scope,

    isActive: (route) ->
      _.str.trim(route, '/') is _.str.trim($location.path(), '/')

