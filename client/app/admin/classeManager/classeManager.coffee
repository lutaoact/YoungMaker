'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider

  .state 'admin.classeManager',
    url: '/classe'
    templateUrl: 'app/admin/classeManager/classeManager.html'
    controller: 'ClasseManagerCtrl'
    authenticate: true
    resolve:
      Classes: (Restangular) ->
        Restangular.all('classes').getList().then (classes) ->
          classes
        , -> []

  .state 'admin.classeManager.detail',
    url: '/:classeId'
    templateUrl: 'app/admin/classeManager/classeManagerDetail.html'
    controller: 'ClasseManagerDetailCtrl'
    authenticate: true

  .state 'admin.classeManager.detail.student',
    url: '/students/:studentId'
    templateUrl: 'app/admin/classeManager/classeManagerStudentDetail.html'
    controller: 'ClasseManagerStudentDetailCtrl'
    authenticate: true
