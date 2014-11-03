'use strict'

angular.module('mauiApp').config (
  $stateProvider
) ->

  $stateProvider.state 'admin.home',
    url: ''
    templateUrl: 'app/admin/adminHome/adminHome.html'
    controller: 'AdminHomeCtrl'
    authenticate: true
