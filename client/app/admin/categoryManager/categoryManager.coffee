'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'admin.categoryManager',
    url: '/categoryManager'
    templateUrl: 'app/admin/categoryManager/categoryManager.html'
    controller: 'CategoryManagerCtrl'

