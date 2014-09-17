'use strict'

angular.module('budweiserApp').controller 'ReceiveQuestionCtrl', (
  $scope
  question
  $modalInstance
) ->
  angular.extend $scope,
    question: question
    confirm: (question) ->
      $modalInstance.close question

