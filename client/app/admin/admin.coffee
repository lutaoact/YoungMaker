'use strict'

angular.module('budweiserApp')
  .config ($stateProvider) ->
    $stateProvider
    .state('admin',
      abstract: true,
      url: '/admin',
      templateUrl: 'app/admin/admin.html'
      controller: 'AdminCtrl'
      authenticate:true
    )
