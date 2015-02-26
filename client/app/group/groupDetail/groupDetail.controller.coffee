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

    getRole: ->
      if !$scope.me._id?
        return 'passerby'
      if $scope.me._id == $scope.group?.creator?._id
        return 'creator'
      else if ($scope.group?.members.indexOf $scope.me._id) >= 0
        return 'member'
      else
        return 'passerby'

    createGroupArticle: ->
      if $scope.getRole() == 'passerby'
        notify
          message: '加入小组后才能发言'
          classes: 'alert-danger'
        return
      $state.go 'groupArticleNew', {groupId: $scope.group._id}

  groupAPI.get().then (group) ->
    if !group
      $state.go '404', url : $state.href($state.current, $state.params),
        location:'replace'
      return
    $scope.group = group
