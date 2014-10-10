angular.module('budweiserApp').controller 'NewQuestionCtrl', (
  $scope
  $timeout
  keyPoints
  categoryId
  $modalInstance
) ->
  angular.extend $scope,
    keyPoints: keyPoints
    selectedKeyPoints:[]
    categoryId: categoryId
    question:
      body: ''
      detailSolution: ''
      categoryId: categoryId
      choices: [{}]

    addKeyPoint: (keyPoint, input) ->
      if keyPoint?
        $scope.selectedKeyPoints.push angular.copy(keyPoint)
        return
      if input?
        keyPoints.post
          name: input
          categoryId: categoryId
        .then (keyPoint) ->
          keyPoints.push keyPoint
          $scope.selectedKeyPoints.push angular.copy(keyPoint)
    removekeyPoint: (index) ->
      $scope.selectedKeyPoints.splice(index, 1)
    validateOptions: ->
      _.find($scope.question.choices, correct:true)?
    addOption: ->
      $scope.question.choices.push {}
    removeOption: (index) ->
      choices = $scope.question.choices
      choices.splice(index, 1)
      choices.push {} if choices.length == 0
    close: ->
      $modalInstance.dismiss('close')
    save: (question, form) ->
      unless form.$valid then return
      question.keyPoints = _.map($scope.selectedKeyPoints, (k) -> k._id)
      $modalInstance.close(question)
      
    onImageUploaded: (key) ->
      key = '/api/assets/images/' + key
      #TODO zhenkunou
#      $scope.question.body += key
