'use strict'

angular.module('budweiserApp')

.directive 'studentLectureAnswers', ->
  restrict: 'EA'
  replace: true
  controller: 'StudentLectureAnswersCtrl'
  templateUrl: 'app/student/studentLectureDetail/studentLectureAnswers.html'
  scope:
    lecture: '='

.controller 'StudentLectureAnswersCtrl', (
  $scope
  Restangular
) ->

  angular.extend $scope,
    displayQuestions: []
    viewState:
      pageSize: 10
    getKeyPoint: (id) -> _.find($scope.keyPoints, _id:id)

    setQuestionType: (type) ->
      $scope.displayQuestions = $scope.lecture?[type]

    submitAnswer: ->
      if $scope.displayQuestions is $scope.lecture.homeworks
        result = _.map $scope.displayQuestions, (question) ->
          questionId: question._id
          answer: _.reduce question.content.body, (answer, option, index) ->
            answer.push(index) if option.$selected
            answer
          , []
        homeworkAnswer =
          subitted: true
          result: result
        Restangular.all('homework_answers').post(homeworkAnswer, lectureId:$scope.lecture._id)
        .then ->
          $scope.displayQuestions.$submitted = true

  $scope.$watch 'lecture', ->
    if !$scope.lecture then return
    $scope.setQuestionType('quizzes')
    Restangular.all('key_points').getList()
    .then (keyPoints) ->
      $scope.keyPoints = keyPoints
    Restangular.all('homework_answers').getList(lectureId:$scope.lecture._id)
    .then (answers)->
      if answers.length > 0
        # TODO: api only return the object
        # check null
        homeworkAnswer = answers[answers.length-1]
        homeworks = $scope.lecture?.homeworks
        homeworks.$submitted = true
        for question in homeworks
          answer = _.find(homeworkAnswer.result, questionId:question._id)?.answer
          question.$correct = answer?.every (item)->
            question.content.body[item].correct

          for option, index in question.content.body
            option.$selected = answer?.indexOf(index) >= 0
