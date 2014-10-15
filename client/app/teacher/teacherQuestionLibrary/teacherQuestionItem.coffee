'use strict'

angular.module('budweiserApp').directive 'teacherQuestionItem', ->
  templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionItem.html'
  restrict: 'E'
  replace: true
  scope:
    index: '@'
    question: '='
    keyPoints: '=keypoints'
    removeCallback: '&'

  controller: ($scope, $document, $timeout)->

    angular.extend $scope,

      expendClick: ->
        $scope.question.$expended = !$scope.question.$expended
        $timeout ->
          if $scope.question.$expended
            targetElement = angular.element(document.getElementById 'question-item-'+$scope.index)
            $document.scrollToElement(targetElement, 70, 500)

      removeQuestion: (question) ->
        $scope.removeCallback?($question:question)
