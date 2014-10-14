'use strict'

angular.module('budweiserApp').directive 'teacherQuestionItem', ->
  templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionItem.html'
  restrict: 'E'
  replace: true
  scope:
    index: '='
    question: '='
    keyPoints: '=keypoints'
    removeCallback: '&'

  controller: ($scope)->

    angular.extend $scope,

      removeQuestion: (question) ->
        $scope.removeCallback?($question:question)
