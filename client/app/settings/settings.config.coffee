'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
  $urlRouterProvider
) ->

  $urlRouterProvider.when('/settings','/settings/profile')

  $stateProvider

  .state 'settings',
    abstract: true
    url: '/settings'
    templateUrl: 'app/settings/settings.html'
    controller: 'SettingsCtrl'
    authenticate: true

  .state 'settings.profile',
    url: '/profile',
    templateUrl: 'app/settings/profile/profile.html'
    controller: 'ProfileCtrl'
    authenticate: true

  .state 'settings.myArticles',
    url: '/articles'
    templateUrl: 'app/settings/article/myArticles.html'
    controller: 'MyArticlesCtrl'
    authenticate: true

  .state 'settings.newArticle',
    url: '/articles/new'
    templateUrl: 'app/settings/article/editArticle.html'
    controller: 'EditArticleCtrl'
    authenticate: true

  .state 'settings.editArticle',
    url: '/articles/:articleId'
    templateUrl: 'app/settings/article/editArticle.html'
    controller: 'EditArticleCtrl'
    authenticate: true
