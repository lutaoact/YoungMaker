'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.course',
    url: '/courses/:courseId'
    templateUrl: 'app/teacher/teacherCourse/teacherCourse.html'
    controller: 'TeacherCourseCtrl'
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
