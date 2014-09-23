'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.questionLibrary',
    url: '/courses/:courseId/lectures/:lectureId/question-library/:questionType'
    templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionLibrary.html'
    controller: 'TeacherQuestionLibraryCtrl'
    authenticate: true
