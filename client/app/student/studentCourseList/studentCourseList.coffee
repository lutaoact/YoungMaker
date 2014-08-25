'use strict'

angular.module('budweiserApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.when('/s','/s/courses')
  $stateProvider.state 'student.courseList',
    url: '/courses'
    templateUrl: 'app/student/studentCourseList/studentCourseList.html'
    controller: 'StudentCourseListCtrl'
