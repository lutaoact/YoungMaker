'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.course',
    url: '/courses/:id'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseDetail.html'
    controller: 'TeacherCourseDetailCtrl'
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
