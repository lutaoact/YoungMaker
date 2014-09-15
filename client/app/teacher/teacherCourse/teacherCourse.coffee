'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.home.newCourse',
    url: '/course/new'
    templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
    controller: 'TeacherNewCourseCtrl'
    authenticate: true
