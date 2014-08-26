'use strict'

angular.module('budweiserApp').config ($stateProvider, $urlRouterProvider) ->

  $stateProvider.state 'teacher.home',
    url: ''
    templateUrl: 'app/teacher/teacherHome/teacherHome.html'
    controller: 'TeacherHomeCtrl'
