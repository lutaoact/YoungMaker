'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.lectureDetail',
    url: '/courses/:courseId/lectures/:id'
    templateUrl: 'app/teacher/teacherLecture/teacherLecture.html'
    controller: 'TeacherLectureCtrl'
  .state 'teacher.lectureNew',
    url: '/courses/:courseId/lectures/new'
    templateUrl: 'app/teacher/teacherLecture/teacherLecture.html'
    controller: 'TeacherLectureCtrl'
