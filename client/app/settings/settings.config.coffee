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
    url: '/profile'
    templateUrl: 'app/settings/profile/profile.html'
    controller: 'ProfileCtrl'
    authenticate: true

  .state 'settings.notice',
    url: '/notice?page'
    templateUrl: 'app/settings/notice/notice.html'
    controller: 'NoticeCtrl'
    authenticate: true