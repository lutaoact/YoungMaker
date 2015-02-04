'use strict'

angular.module('mauiApp')

.controller 'UserCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    user: null

  Restangular.one('users', $state.params.userId).get()
  .then (user) ->
    $scope.user = user
