'use strict'

angular.module('budweiserApp').controller 'PushQuestionCtrl', (
  $scope
  classe
  socket
  lecture
  question
  keyPoints
  Restangular
  $modalInstance
) ->

#  TODO 是不是可以不用了，直线用socket推送过来的answers算
#  updateRealTimeStats = ->
#    Restangular.all('quiz_stats')
#    .customGET('real_time', {lectureId:lecture._id, questionId:question._id})
#    .then (data) ->
#      console.debug 'real_time', data

  makeQuestionStats = ->
    results = _.pluck $scope.answers, 'result'
    _.countBy(_.flatten(results), (ele) -> ele)

  angular.extend $scope,
    pushed: false
    classe: classe
    lecture: lecture
    question: question
    answers: []
    questionStats: {}

    getKeyPoint: (id) -> _.find(keyPoints, _id:id)

    push: ->
      if $scope.pushed
        socket.removeHandler 'quiz_answer'
        $modalInstance.dismiss('close')
      else
        $scope.pushed = true
        Restangular.all('questions').customPOST
          questionId: question._id
          lectureId: lecture._id
          classId: classe._id
        , 'quiz'
        .then ->
          socket.setHandler 'quiz_answer', (answer) ->
            if answer.questionId is question._id &&
               answer.lectureId is lecture._id &&
               classe.students.indexOf(answer.userId) >= 0
              $scope.answers.push answer
              $scope.questionStats = makeQuestionStats()
