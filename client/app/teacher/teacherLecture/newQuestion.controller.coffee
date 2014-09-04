angular.module('budweiserApp').controller 'NewQuestionCtrl', (
  $scope
  categoryId
  keyPoints
  $modalInstance
) ->
  angular.extend $scope,
    keyPoints: keyPoints
    selectedKeyPoints:[]
    question:
      solution: ''
      categoryId: categoryId
      content:
        title: ''
        body: [{}]

    addkeyPoint: (keyPoint) ->
      $scope.selectedKeyPoints.push angular.copy(keyPoint)
    removekeyPoint: (index) ->
      $scope.selectedKeyPoints.splice(index, 1)
    addOption: ->
      $scope.question.content.body.push {}
    removeOption: (index) ->
      $scope.question.content.body.splice(index, 1)
    close: ->
      $modalInstance.dismiss('close')
    save: (question, form) ->
      unless form.$valid then return
      question.keyPoints = _.map($scope.selectedKeyPoints, (k) -> k._id)
      $modalInstance.close(question)
