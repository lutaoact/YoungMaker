angular.module('budweiserApp').controller 'QuestionLibraryCtrl', (
  $scope
  questions
  $modalInstance
) ->

  angular.extend $scope,
    keyword: ''
    questions: questions
    currentPage: 1
    itemsPerPage: 5
    displayItems: []

    close: ->
      $modalInstance.dismiss('close')
    add: (question) ->
      $modalInstance.close angular.copy(question)
