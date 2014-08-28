'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'admin.classeManager',
    url: '/classeManager'
    templateUrl: 'app/admin/classeManager/classeManager.html'
    controller: 'ClasseManagerCtrl'
    resolve:
      CurrentUser: (Auth)->
        Auth.getCurrentUser()

  .state 'admin.classeManager.detail',
    url: '/:classeId'
    templateUrl: 'app/admin/classeManager/classeManager.detail.html'
    controller: 'ClasseManagerDetailCtrl'
