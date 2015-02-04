'use strict'

angular.module('mauiApp').directive 'userTile', ->
  templateUrl: 'app/user/userTile/userTile.html'
  restrict: 'EA'
  replace: true
  scope:
    user: '='
    me: '='

  controller: (
    $q
    $scope
    $state
    Restangular
  ) ->

    angular.extend $scope,
      numFollower: null
      numFollowing: null
      follow: null

      toggleFollow: ->
        if $scope.follow
          Restangular
            .one('follows', $state.params.userId)
            .remove()
            .then refresh
        else
          Restangular
            .all('follows')
            .post(to: $state.params.userId)
            .then refresh

    refresh = ->
      # 检查我是否关注了该用户
      $q (resolve) ->
        if $scope.me._id
          resolve Restangular.one('follows', $state.params.userId).get()
        else
          resolve(null)
      .then (follow) ->
        $scope.follow = follow

      # 检查该用户的粉丝数，关注数
      Restangular
        .one('follows', 'num')
        .get(userId: $state.params.userId)
        .then (data) ->
          $scope.numFollower = data.numFollower
          $scope.numFollowing = data.numFollowing

    $scope.$watch 'me', refresh

