'use strict'

angular.module('budweiserApp').controller 'ReceiveQuestionCtrl', (
  $scope
  question
  answer
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    question: question
    submitted: false

    confirm: (question) ->
      if $scope.submitted
        $modalInstance.dismiss('close')
      else
        Restangular.one('quiz_answers', answer._id).patch
          result: _.reduce question.content.body, (result, option, index) ->
            result.push(index) if option.$selected
            result
          , []
        .then ->
          $scope.submitted = true

  for option, index in question.content.body
    option.$selected = answer.result.indexOf(index) != -1
