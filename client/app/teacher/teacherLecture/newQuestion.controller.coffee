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
      solution: ''
      categoryId: categoryId
      content:
        imageUrls : []
        title: ''
        body: [{}]

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
      
    onImageUploaded: (key) ->
      console.log 'The key is ', key
      key = '/api/assets/images/' + key
      $scope.question.content.imageUrls.push key
