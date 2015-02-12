'use scrict'

angular.module('mauiApp')

.controller 'GroupMemberListCtrl', (
  $scope
  $state
  Restangular
) ->

#  angular.extend $scope,

  # TODO: pagination!
  Restangular.one('groups', $state.params.groupId).one('members')
  .get()
  .then (members)->
    $scope.groupMembers = members
