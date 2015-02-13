'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
) ->

  $stateProvider

  .state 'notices',
    url: '/notices'
    templateUrl: 'app/notice/notice.html'
    abstract: true

  .state 'notices.unread',
    url: '?page'
    controller: 'NoticeCtrl'

  .state 'notices.read',
    url: '/read?page'
    controller: 'NoticeCtrl'
