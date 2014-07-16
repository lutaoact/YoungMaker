'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacherCourseNew',
    url: '/t/courses/new'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseNew.html'
    controller: 'TeacherCourseNewCtrl'
  .state 'teacherCourse',
    url: '/t/courses/:id'
    templateUrl: 'app/teacher/teacherCourse/teacherCourse.html'
    controller: 'TeacherCourseCtrl'

