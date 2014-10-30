'use strict'

angular.module('mauiApp').directive 'questionAnswer', ->
  templateUrl: 'app/directives/questionAnswer/questionAnswer.html'
  restrict: 'E'
  replace: true
  scope:
    question: '='
    keyPoints: '=keypoints'
  link: (scope, element, attrs) ->

  controller: ($scope)->
    angular.extend $scope,
      getCorrectInfo: (question) ->
        _.reduce question.choices, (result, choice, index) ->
          if choice.correct is true
            result += String.fromCharCode(65+index)
          result
        , ''

      getKeyPointName: (keypoint) ->
        keypoint.name ? _.find($scope.keyPoints, _id:keypoint)?.name
