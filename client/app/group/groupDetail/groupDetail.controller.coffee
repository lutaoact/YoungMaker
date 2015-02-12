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

    createGroupArticle: ->
      if $scope.getRole() == 'passerby'
        notify
          message: '加入小组后才能发言'
          classes: 'alert-danger'
        return
      $state.go 'groupArticleNew', {groupId: $scope.group._id}

  groupAPI.get().then (group) ->
    $scope.group = group
