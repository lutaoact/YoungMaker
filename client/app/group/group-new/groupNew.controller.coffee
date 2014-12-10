angular.module('mauiApp')

.controller 'GroupNewCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->
  angular.extend $scope,
    groupData:
      title: null
      info: null

    createGroup: (form) ->
      if !form.$valid then return
      console.log $scope.groupData