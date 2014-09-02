angular.module('budweiserApp').controller 'NewQuestionCtrl', (
  $scope
  course
  $modalInstance
) ->
  angular.extend $scope,
    question:
      solution: ''
      categoryId: course.categoryId
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