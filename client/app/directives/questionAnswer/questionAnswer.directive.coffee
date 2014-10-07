'use strict'

angular.module('budweiserApp').directive 'questionAnswer', ->
  templateUrl: 'app/directives/questionAnswer/questionAnswer.html'
  restrict: 'E'
  replace: true
  scope:
    question: '='
  link: (scope, element, attrs) ->

  controller: ($scope)->
    angular.extend $scope,
      getCorrectInfo: (question) ->
        _.reduce question.content.body, (result, option, index) ->
          if option.correct==true
            result += String.fromCharCode(65+index)
          result
        , ''

      getKeyPoint: (id) -> _.find($scope.keyPoints, _id:id)
