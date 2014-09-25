'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.questionLibrary',
    url: '/course/:courseId/question-library'
    templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionLibrary.html'
    controller: 'TeacherQuestionLibraryCtrl'
    authenticate: true
