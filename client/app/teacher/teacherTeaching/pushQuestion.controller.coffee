'use strict'

angular.module('budweiserApp').controller 'PushQuestionCtrl', (
  $scope
  classe
  socket
  lecture
  question
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    pushed: false
    classe: classe
    lecture: lecture
    question: question
    answers: {}
    questionStats: {}

    getAnswersNum: -> _.keys($scope.answers).length

    close: ->
      socket.removeHandler 'quiz_answer'
      $modalInstance.dismiss('close')

    push: ->
      if $scope.pushed
        $scope.close()
      else
        $scope.pushed = true
        $scope.questionStats = makeQuestionStats()
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
              $scope.answers[answer.userId] = answer
              $scope.questionStats = makeQuestionStats()

  makeQuestionStats = ->
    resultsDict = _
    .chain($scope.answers)
    .values()
    .pluck('result')
    .flatten((item) -> item)
    .countBy()
    .value()
    options:
      chart:
        type: 'bar'
      plotOptions:
        series:
          stacking: "normal"
    title:
      text: question.content.title
    subtitle:
      text: "学生选择选项统计"
    loading: false
    series: [
      name: '选择人数'
      data: _.map(question.content.body, (option, index) -> resultsDict[index] ? 0)
    ]
    yAxis:
      min: 0
      max: classe.students.length
      tickInterval: 1
    xAxis:
      categories: _.map(question.content.body, (option, index) -> String.fromCharCode(65+index))
      max: question.content.body.length - 1
      min: 0
    useHighStocks: false

