angular.module('mauiApp')

.controller 'GroupDetailCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
  $modal
) ->
  groupAPI = Restangular.one('groups', $state.params.groupId)

  angular.extend $scope,
    group: null

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

    createGroupArticle: ->
      if $scope.getRole() == 'passerby'
        notify
          message: '加入小组后才能发言'
          classes: 'alert-danger'
        return
      $state.go 'groupArticleNew', {groupId: $scope.group._id}

    getRole: ->
      if !$scope.me._id?
        return 'passerby'
      if $scope.me._id == $scope.group?.creator?._id
        return 'creator'
      else if ($scope.group?.members.indexOf $scope.me._id) >= 0
        return 'member'
      else
        return 'passerby'

  groupAPI.get().then (group) ->
    $scope.group = group

  Restangular.one('groups', $state.params.groupId).one('members')
  .get()
  .then (members)->
    $scope.groupMembers = members