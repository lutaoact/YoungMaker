'use strict'

angular.module('mauiApp')

.directive 'userTile', ->
  restrict: 'EA'
  replace: true
  scope:
    # type 默认为 normal : 用户个人主页下的 user-tile
    # small              : 推荐的用户下的 user-tile
    # middle             : 用户关注、粉丝下的 user-tile
    # normal-articles    : 文章详情下的 user-tile
    # normal-courses     : 趣课详情下的 user-tile
    type: '@'
    user: '='
    me: '='
  templateUrl: (element, attrs) ->
    switch attrs.type
      when 'small'
        'app/user/userTile/userTileSmall.html'
      when 'middle'
        'app/user/userTile/userTileMiddle.html'
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
    userStatus: null
    courses: null
    articles: null
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

    $scope.type ?= 'normal'
    switch $scope.type
      when 'middle', 'normal'
        # 获取该用户的粉丝数，关注数
        Restangular
          .one('users', 'num')
          .get(userId: $scope.user._id)
          .then (status) ->
            $scope.userStatus = status
      when 'normal-articles'
        # 获取该用户创建的最新文章
        Restangular
          .all('articles')
          .getList(
            author: $scope.user._id
            limit: 5
          )
        .then (articles) ->
          $scope.articles = articles
      when 'normal-courses'
        # 获取该用户创建的最新趣课
        Restangular
          .all('courses')
          .getList(
            author: $scope.user._id
            limit: 5
          )
        .then (courses) ->
          $scope.courses = courses

  $scope.$watchGroup ['me', 'user'], refresh

