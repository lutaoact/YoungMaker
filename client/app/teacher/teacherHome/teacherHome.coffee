'use strict'

angular.module('budweiserApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.when("/t", "/t/home")
  $stateProvider.state 'teacher.home',
    url: '/home'
    templateUrl: 'app/teacher/teacherHome/teacherHome.html'
    controller: 'TeacherhomeCtrl'
