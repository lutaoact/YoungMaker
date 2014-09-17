'use strict'

angular.module('budweiserApp').controller 'PushQuestionCtrl', (
  $scope
  question
  keyPoints
  $modalInstance
) ->
  angular.extend $scope,
    question: question
    getKeyPoint: (id) -> _.find(keyPoints, _id:id)
    close: ->
      $modalInstance.dismiss('close')
    confirm: (question) ->
      $modalInstance.close question

