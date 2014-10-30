'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'student.courseDetail',
    url: '/courses/:courseId'
    templateUrl: 'app/student/studentCourseDetail/studentCourseDetail.html'
    controller: 'StudentCourseDetailCtrl'
    authenticate: true

