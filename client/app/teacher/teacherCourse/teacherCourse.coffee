'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.coursesDetail',
    url: '/courses/:id'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseDetail.html'
    controller: 'TeacherCourseDetailCtrl'
  .state 'teacher.coursesNew',
    url: '/courses/new'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseDetail.html'
    controller: 'TeacherCourseDetailCtrl'
