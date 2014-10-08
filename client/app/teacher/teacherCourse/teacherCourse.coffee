'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'teacher.course',
    url: '/courses/:courseId'
    templateUrl: 'app/teacher/teacherCourse/teacherCourse.html'
    controller: 'TeacherCourseCtrl'
    authenticate: true
