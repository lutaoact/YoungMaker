angular.module('budweiserApp').controller 'NewQuestionCtrl', (
  $scope
  categoryId
  $modalInstance
) ->
  angular.extend $scope,
    question:
      solution: ''
      categoryId: categoryId
      content:
        title: ''
        body: [{}]
    addOption: ->
      $scope.question.content.body.push {}
    removeOption: (index) ->
      $scope.question.content.body.splice(index, 1)
    close: ->
      $modalInstance.dismiss('close')
    save: (question, form) ->
      unless form.$valid then return
      $modalInstance.close(question)