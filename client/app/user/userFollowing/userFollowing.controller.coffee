angular.module 'mauiApp'

# 我正在关注的人
.controller 'UserFollowingCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    following: null
    pageConf:
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 10

    changePage: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  Restangular
    .all('follows')
    .getList(
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
      fromUserId: $state.params.userId
    )
    .then (following) ->
      $scope.following = following
