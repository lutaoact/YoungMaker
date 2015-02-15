angular.module 'mauiApp'

# 我的粉丝
.controller 'UserFollowersCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    followers: null
    pageConf:
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 20

    reload: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  Restangular
    .all('follows')
    .getList(
      toUserId: $state.params.userId
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (followers) ->
      $scope.followers = followers
