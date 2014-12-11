angular.module('mauiApp')

.controller 'GroupCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->
  groupAPI = Restangular.one('groups', $state.params.groupId)

  angular.extend $scope,
    me: Auth.getCurrentUser()
    group: null

  groupAPI.get().then (group) ->
    $scope.group = group