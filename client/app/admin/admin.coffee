'use strict'

angular.module('budweiserApp')
  .config ($stateProvider) ->
    $stateProvider
    .state('admin',
      url: '/admin',
      templateUrl: 'app/admin/admin.html'
      controller: 'AdminCtrl'
    )