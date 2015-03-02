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

    $scope.$emit 'updateTitle', ->
      if $scope.group
        "小组全部成员(#{$scope.group.members.length}) - #{$scope.group.name}"
