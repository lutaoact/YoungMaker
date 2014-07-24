'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'admin.classeManager',
    url: '/classeManager'
    templateUrl: 'app/admin/classeManager/classeManager.html'
    controller: 'ClasseManagerCtrl'
  .state 'admin.classeDetail',
    url: '/classeDetail/:id'
    templateUrl: 'app/admin/classeManager/classeDetail.html'
    controller: 'ClasseDetailCtrl'
