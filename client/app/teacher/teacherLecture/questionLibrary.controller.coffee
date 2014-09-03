angular.module('budweiserApp').controller 'QuestionLibraryCtrl', (
  $scope
  questions
  $modalInstance
) ->

  angular.extend $scope,
    questions: questions

    displayItems: []
    itemsPerPage: 6
    currentPage: 1

    close: ->
      $modalInstance.dismiss('close')
    add: (question) ->
      $modalInstance.close angular.copy(question)
