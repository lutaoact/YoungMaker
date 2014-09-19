'use strict'

angular.module('budweiserApp').controller 'ReceiveQuestionCtrl', (
  $scope
  answer
  question
  teacherId
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    question: question
    submitted: false

    confirm: (question) ->
      if $scope.submitted
        $modalInstance.dismiss('close')
      else
        selectedOptions = _.reduce question.content.body, (result, option, index) ->
          result.push(index) if option.$selected
          result
        , []
        Restangular.one('quiz_answers', answer._id)
        .patch({result: selectedOptions}, {teacherId: teacherId})
        .then ->
          $scope.submitted = true

  for option, index in question.content.body
    option.$selected = answer.result.indexOf(index) != -1
