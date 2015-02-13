'use strict'

angular.module('mauiApp')

.controller 'UserCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    user: null

  if $state.params.userId
    Restangular
      .one('users', $state.params.userId)
      .get()
      .then (user) ->
        $scope.user = user
  else
    $scope.user = angular.copy($scope.me)
