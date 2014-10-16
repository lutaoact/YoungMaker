'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'admin',
    url: '/a'
    templateUrl: 'app/admin/admin.html'
    controller: 'AdminCtrl'
    abstract: true
    authenticate: true
    resolve:
      CurrentUser: (Auth) -> Auth.getCurrentUser()
