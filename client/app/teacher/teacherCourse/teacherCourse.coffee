'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.course',
    url: '/courses/:id'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseDetail.html'
    controller: 'TeacherCourseDetailCtrl'
