'use strict'

angular.module('budweiserApp')
.config ($stateProvider) ->
  $stateProvider
  .state 'admin',
    abstract: true,
    url: '/admin',
    templateUrl: 'app/admin/admin.html'
    controller: 'AdminCtrl'
    resolve:
      CurrentUser: (Auth)->
        Auth.getCurrentUser()
    authenticate:true
