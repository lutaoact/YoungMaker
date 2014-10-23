'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider

  .state 'admin.categoryManager',
    url: '/categoryManager'
    templateUrl: 'app/admin/categoryManager/categoryManager.html'
    controller: 'CategoryManagerCtrl'
    authenticate: true
    resolve:
      Categories: (Restangular) ->
        Restangular.all('categories').getList().then (categories) ->
          categories
        , -> []

  .state 'admin.categoryManager.detail',
    url: '/:categoryId'
    templateUrl: 'app/admin/categoryManager/categoryManagerDetail.html'
    controller: 'CategoryManagerDetailCtrl'
    authenticate: true
