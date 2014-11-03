'use strict'

angular.module('mauiApp').controller 'AdminHomeCtrl', (
  Auth
  $scope
) ->

  angular.extend $scope,
    auth: Auth

