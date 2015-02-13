'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
  $urlRouterProvider
) ->

  $stateProvider

  .state 'settings',
    abstract: true
    url: '/settings'
    templateUrl: 'app/settings/settings.html'
    controller: 'SettingsCtrl'
    authenticate: true

  .state 'settings.notice',
    url: '/notice?page'
    templateUrl: 'app/settings/notice/notice.html'
    controller: 'NoticeCtrl'
    authenticate: true
