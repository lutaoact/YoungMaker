angular.module('mauiApp')

.controller 'GroupListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->

  angular.extend $scope,
    groups = []


  Restangular.all('groups').getList()
  .then (groups) ->
    $scope.groups = groups