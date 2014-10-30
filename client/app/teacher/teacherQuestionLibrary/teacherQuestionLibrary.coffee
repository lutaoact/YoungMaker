'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.questionLibrary',
    url: '/course/:courseId/question-library'
    templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionLibrary.html'
    controller: 'TeacherQuestionLibraryCtrl'
    authenticate: true
    resolve:
      KeyPoints: (Restangular) ->
        Restangular.all('key_points').getList().then (keyPoints) ->
          keyPoints
        , -> []
