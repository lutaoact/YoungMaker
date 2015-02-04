'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
) ->

  $stateProvider

  .state 'user',
    url: '/users/:userId'
    templateUrl: 'app/user/user.html'
    controller: 'UserCtrl'
    abstract: true

  .state 'user.home',
    url: ''
    templateUrl: 'app/user/userHome/userHome.html'
    controller: 'UserHomeCtrl'

  .state 'user.following',
    url: '/following'
    templateUrl: 'app/user/following/following.html'
    controller: 'FollowingCtrl'

  .state 'user.followers',
    url: '/followers'
    templateUrl: 'app/user/followers/followers.html'
    controller: 'FollowersCtrl'
