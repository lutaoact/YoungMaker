'use strict'

angular.module('budweiserApp').controller 'PushQuestionCtrl', (
  $scope
  question
  $modalInstance
) ->
  angular.extend $scope,
    question: question
    close: ->
      $modalInstance.dismiss('close')
    confirm: (question) ->
      $modalInstance.close question

