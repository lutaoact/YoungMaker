'use strict'

angular.module('mauiApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.when('/s','/s/courses')
  $stateProvider.state 'student.home',
    url: '/courses'
    templateUrl: 'app/student/studentCourseList/studentCourseList.html'
    controller: 'StudentCourseListCtrl'
    authenticate: true
    navClasses: 'home'
