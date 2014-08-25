'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'student.courseDetail',
    url: '/courses/:courseId'
    templateUrl: 'app/student/studentCourseDetail/studentCourseDetail.html'
    controller: 'StudentCourseDetailCtrl'
