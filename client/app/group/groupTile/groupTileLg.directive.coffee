'use strict'

angular.module('mauiApp').directive 'groupTileLg', ()->
  templateUrl: 'app/group/groupTile/groupTileLg.html'
  restrict: 'E'
  replace: true
  scope:
    group: '='
    me: '='

  controller: ($scope, Restangular, notify, $state, $modal)->
    angular.extend $scope,
      editGroupInfo: ->
        $modal.open
          templateUrl: 'app/group/editGroup/editGroupModal.html'
          controller: 'EditGroupModalCtrl'
          size: 'sm'
          resolve:
            group: -> angular.copy($scope.group)
        .result.then (newGroup) ->
          angular.extend $scope.group, newGroup

      joinGroup: ->
        Restangular.one('groups', $scope.group._id).one('join')
        .post()
        .then (data)->
          $scope.group.members = data.members
          notify
            message: '已加入小组'
            classes: 'alert-success'
        .catch (error) ->
          $scope.errors = error?.data?.errors

      leaveGroup: ->
        Restangular.one('groups', $scope.group._id).one('leave')
        .post()
        .then (data)->
          $scope.group.members = data.members
          notify
            message: '已退出小组'
            classes: 'alert-success'
        .catch (error) ->
          $scope.errors = error?.data?.errors

      getRole: ->
        if !$scope.me._id?
          return 'passerby'
        if $scope.me._id == $scope.group?.creator?._id
          return 'creator'
        else if ($scope.group?.members.indexOf $scope.me._id) >= 0
          return 'member'
        else
          return 'passerby'

    $scope.$watch 'group', (group)->
      if group?
        Restangular.one('groups', group._id).one('members')
        .get()
        .then (members)->
          $scope.groupMembers = members
