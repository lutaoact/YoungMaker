angular.module('budweiserApp').controller 'NewQuestionCtrl', (
  $scope
  categoryId
  keyPoints
  $modalInstance
) ->
  angular.extend $scope,
    keyPoints: keyPoints
    selectedKeyPoints:[]
    categoryId: categoryId
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
    validateOptions: ->
      _.find($scope.question.content.body, correct:true)?
    addOption: ->
      $scope.question.content.body.push {}
    removeOption: (index) ->
      options = $scope.question.content.body
      options.splice(index, 1)
      options.push {} if options.length == 0
    close: ->
      $modalInstance.dismiss('close')
    save: (question, form) ->
      unless form.$valid then return
      question.keyPoints = _.map($scope.selectedKeyPoints, (k) -> k._id)
      $modalInstance.close(question)
