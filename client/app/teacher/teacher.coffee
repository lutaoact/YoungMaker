'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher',
    abstract: true,
    url: '/t'
    templateUrl: 'app/teacher/teacher.html'
    controller: 'TeacherCtrl'
    authenticate: true
    resolve:
      Categories: (Restangular) ->
        Restangular.all('categories').getList().then (categories) ->
          categories
        , -> []
      Classes: (Restangular) ->
        Restangular.all('classes').getList().then (classes) ->
          classes
        , -> []
      Courses: (Restangular) ->
        Restangular.all('courses').getList().then (courses) ->
          courses
        , -> []
