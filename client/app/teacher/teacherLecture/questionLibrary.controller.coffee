angular.module('budweiserApp').controller 'QuestionLibraryCtrl', (
  $scope
  questions
  keyPoints
  $modalInstance
) ->

  angular.extend $scope,
    keyword: ''
    questions: questions
    currentPage: 1
    itemsPerPage: 5
    displayItems: []

    getKeyPoint: (id) -> _.find(keyPoints, _id:id)
    close: ->
      $modalInstance.dismiss('close')
    add: (question) ->
      $modalInstance.close angular.copy(question)
