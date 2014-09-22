'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.courseStats',
    url: '/courses/:courseId/stats'
    templateUrl: 'app/teacher/teacherCourseStats/teacherCourseStats.html'
    controller: 'TeacherCourseStatsCtrl'
    authenticate: true
    abstract: true
    resolve:
      Categories: (Restangular) ->
        Restangular.all('categories').getList().then (categoaries) ->
          categoaries
        , -> []
      Classes: (Restangular) ->
        Restangular.all('classes').getList().then (classes) ->
          classes
        , -> []

  .state 'teacher.courseStats.all',
    url: ''
    templateUrl:'app/teacher/teacherCourseStats/teacherCourseStats.all.html'
    # controller: 'TeacherCourseStatsCtrl'

  .state 'teacher.courseStats.student',
    url: '/students/:studentId'
    templateUrl:'app/teacher/teacherCourseStats/teacherCourseStats.student.html'
