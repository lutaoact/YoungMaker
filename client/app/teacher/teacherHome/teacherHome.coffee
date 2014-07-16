'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacherHome',
    url: '/t'
    templateUrl: 'app/teacher/teacherHome/teacherHome.html'
    controller: 'TeacherhomeCtrl'
