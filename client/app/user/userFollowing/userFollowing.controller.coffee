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
      itemsPerPage: 20

    reload: ->
      $state.go $state.current,
        keyword: $scope.pageConf.keyword

  $scope.$emit 'updateTitle', ->
    if $scope.user
      $scope.user.name + '的关注'

  Restangular
    .all('follows')
    .getList(
      fromUserId: $state.params.userId
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (following) ->
      $scope.following = following
