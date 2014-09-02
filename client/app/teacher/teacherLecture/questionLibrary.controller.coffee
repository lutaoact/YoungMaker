angular.module('budweiserApp').controller 'QuestionLibraryCtrl', (
  $scope
  questions
  $modalInstance
) ->
  angular.extend $scope,
    questions: questions
    close: ->
      $modalInstance.dismiss('close')
    add: (question) ->
      $modalInstance.close angular.copy(question)
