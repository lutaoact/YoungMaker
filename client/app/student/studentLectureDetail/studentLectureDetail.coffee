'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'student.lectureDetail',
    url: '/courses/:courseId/lectures/:lectureId'
    templateUrl: 'app/student/studentLectureDetail/studentLectureDetail.html'
    controller: 'StudentLectureDetailCtrl'
    authenticate: true
