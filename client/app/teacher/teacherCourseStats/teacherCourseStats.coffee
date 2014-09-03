'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.courseStats',
    url: '/courses/:courseId/stats'
    templateUrl: 'app/teacher/teacherCourseStats/teacherCourseStats.html'
    controller: 'TeacherCourseStatsCtrl'
    authenticate: true
    resolve:
      Categories: (Restangular) ->
        Restangular.all('categories').getList().then (categoaries) ->
          categoaries
        , -> []
      Classes: (Restangular) ->
        Restangular.all('classes').getList().then (classes) ->
          classes
        , -> []
