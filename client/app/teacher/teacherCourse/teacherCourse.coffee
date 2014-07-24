'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.courseNew',
    url: '/courses/new'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseNew.html'
    controller: 'TeacherCourseNewCtrl'
  .state 'teacher.courseDetail',
    url: '/courses/:id'
    templateUrl: 'app/teacher/teacherCourse/teacherCourseDetail.html'
    controller: 'TeacherCourseDetailCtrl'
  .state 'teacher.course',
    url: '/courses'
    templateUrl: 'app/teacher/teacherCourse/teacherCourse.html'
    controller: 'TeacherCourseCtrl'

