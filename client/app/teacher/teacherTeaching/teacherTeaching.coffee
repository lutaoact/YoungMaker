'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.teaching',
    url: '/courses/:courseId/lectures/:lectureId/teaching/:classeId'
    templateUrl: 'app/teacher/teacherTeaching/teacherTeaching.html'
    controller: 'TeacherTeachingCtrl'
    authenticate: true
    navClasses: 'hide'
