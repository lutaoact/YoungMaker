'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'teacher.home',
    url: ''
    templateUrl: 'app/teacher/teacherHome/teacherHome.html'
    controller: 'TeacherHomeCtrl'
    authenticate: true
    navClasses: 'home'
