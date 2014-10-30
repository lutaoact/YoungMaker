'use strict'

angular.module('mauiApp').controller 'PubQuestionCtrl', (
  $scope
  classe
  socket
  $filter
  lecture
  question
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    publishing: false
    classe: classe
    lecture: lecture
    question: question
    submittedAnswers: {}
    publishedAnswers: []
    questionStats: null

    getAnswersNum: -> _.keys($scope.submittedAnswers).length

    close: ->
      socket.removeHandler 'quiz_answer'
      $modalInstance.dismiss('close')

    publish: ->
      $scope.publishing = true
      Restangular.all('questions').customPOST
        questionId: question._id
        lectureId: lecture._id
        classId: classe._id
      , 'quiz'
      .then (publishedAnswers) ->
        $scope.publishing = false
        $scope.publishedAnswers = publishedAnswers
        publishedAnswerIds = _.pluck $scope.publishedAnswers, '_id'
        $scope.questionStats = makeQuestionStats()
        socket.setHandler 'quiz_answer', (answer) ->
          if answer.questionId is question._id &&
             answer.lectureId is lecture._id &&
             publishedAnswerIds.indexOf(answer._id) >= 0
            $scope.submittedAnswers[answer.userId] = answer
            $scope.questionStats = makeQuestionStats()

  makeQuestionStats = ->
    resultsDict = _
    .chain($scope.submittedAnswers)
    .values()
    .pluck('result')
    .flatten((item) -> item)
    .countBy()
    .value()
    options:
      chart:
        type: 'bar'
      plotOptions:
        bar:
          dataLabels:
            enabled: true
            style:
              fontWeight: 'bold'
      tooltip:
        valueSuffix: ' 人'
    title:
      text: $filter('questionTitle')(question.body)
    subtitle:
      text: "学生选择选项统计"
    yAxis:
      min: 0
      max: $scope.publishedAnswers.length
      tickInterval: $scope.publishedAnswers.length
      title:
        text: '人数'
        align: 'high'
      labels:
        overflow: 'justify'
    xAxis:
      categories: _.map(question.choices, (option, index) -> String.fromCharCode(65+index))
      max: question.choices.length - 1
      min: 0
    series: [
      name: '选择人数'
      data: _.map(question.choices, (option, index) -> resultsDict[index] ? 0)
    ]

