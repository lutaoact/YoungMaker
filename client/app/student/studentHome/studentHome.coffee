'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'student',
    url: '/s'
    templateUrl: 'app/student/studentHome/studentHome.html'
    controller: 'StudentHomeCtrl'
    abstract: true
