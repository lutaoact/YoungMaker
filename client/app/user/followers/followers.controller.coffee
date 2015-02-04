angular.module 'mauiApp'

# 我的粉丝
.controller 'FollowersCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    followers: null

  Restangular
    .all('follows')
    .getList(
      from: 0
      limit: 20
      toUserId: $state.params.userId
    )
    .then (follows) ->
      $scope.followers = _.map follows, (f) -> f.from
