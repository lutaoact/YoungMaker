'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'studentHome',
    url: '/s'
    templateUrl: 'app/student/studentHome/studentHome.html'
    controller: 'StudenthomeCtrl'
