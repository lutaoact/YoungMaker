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
    url: '?page'
    templateUrl: 'app/user/userActivities/userActivities.html'
    controller: 'UserActivitiesCtrl'

  .state 'user.courses',
    url: '/courses?page'
    templateUrl: 'app/user/userCourses/userCourses.html'
    controller: 'UserCoursesCtrl'

  .state 'user.articles',
    url: '/articles?page'
    templateUrl: 'app/user/userArticles/userArticles.html'
    controller: 'UserArticlesCtrl'

  .state 'user.following',
    url: '/following?page'
    templateUrl: 'app/user/userFollowing/userFollowing.html'
    controller: 'UserFollowingCtrl'

  .state 'user.followers',
    url: '/followers?page'
    templateUrl: 'app/user/userFollowers/userFollowers.html'
    controller: 'UserFollowersCtrl'
