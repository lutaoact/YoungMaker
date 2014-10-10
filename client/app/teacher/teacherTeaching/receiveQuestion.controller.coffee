'use strict'

angular.module('budweiserApp').controller 'ReceiveQuestionCtrl', (
  $scope
  answer
  question
  teacherId
  Restangular
  $modalInstance
  $rootScope
) ->

  angular.extend $scope,

    question: question
    submitted: false

    close: ->
      $modalInstance.dismiss('close')

    confirm: (question) ->
      if $scope.submitted
        $scope.close()
      else
        selectedOptions = _.reduce question.choices, (result, option, index) ->
          result.push(index) if option.$selected
          result
        , []
        Restangular.one('quiz_answers', answer._id)
        .patch({result: selectedOptions}, {teacherId: teacherId})
        .then (answer)->
          $rootScope.$broadcast 'quiz.answered', question, answer
          $scope.submitted = true

  for option, index in question.choices
    option.$selected = answer.result.indexOf(index) != -1
