'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'student.courseStats',
    url: '/courses/:courseId/stats'
    templateUrl: 'app/student/studentCourseStats/studentCourseStats.html'
    controller: 'StudentCourseStatsCtrl'
    authenticate: true
