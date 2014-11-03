'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'teacher',
    abstract: true,
    url: '/t'
    templateUrl: 'app/teacher/teacher.html'
    controller: 'TeacherCtrl'
    authenticate: true
