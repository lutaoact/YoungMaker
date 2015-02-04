angular.module 'mauiApp'

# 我正在关注的人
.controller 'FollowingCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    following: null

  Restangular
    .all('follows')
    .getList(
      from: 0
      limit: 20
      fromUserId: $state.params.userId
    )
    .then (follows) ->
      $scope.following = _.map follows, (f) -> f.to
