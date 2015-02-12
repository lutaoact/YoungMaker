'use strict'

angular.module('mauiApp')

.directive 'userTile', ->
  restrict: 'EA'
  replace: true
  scope:
    size: '@'
    user: '='
    me: '='
  templateUrl: (element, attrs) ->
    switch attrs.size
      when 'sm'
        'app/user/userTile/userTileSm.html'
      when 'md'
        'app/user/userTile/userTileMd.html'
      else
        'app/user/userTile/userTile.html'
  controller: 'UserTileCtrl'

.controller 'UserTileCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    userData: null
    follow: null

    toggleFollow: ->
      if $scope.follow
        Restangular
          .one('follows', $scope.user._id)
          .remove()
          .then refresh
      else
        Restangular
          .all('follows')
          .post(to: $scope.user._id)
          .then refresh

  refresh = ->
    if !$scope.me or !$scope.user then return

    # 检查我是否关注了该用户
    $q (resolve) ->
      if $scope.me._id
        resolve Restangular.one('follows', $scope.user._id).get()
      else
        resolve(null)
    .then (follow) ->
      $scope.follow = follow

    # 检查该用户的粉丝数，关注数
    if $scope.size isnt 'sm'
      Restangular
        .one('users', 'num')
        .get(userId: $scope.user._id)
        .then (data) ->
          $scope.userData = data

  $scope.$watchGroup ['me', 'user'], refresh

