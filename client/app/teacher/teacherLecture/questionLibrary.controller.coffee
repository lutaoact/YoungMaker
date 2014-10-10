'use strict'

angular.module('budweiserApp')

.directive 'questionLibrary', ->
  restrict: 'EA'
  replace: true
  controller: 'QuestionLibraryCtrl'
  templateUrl: 'app/teacher/teacherLecture/questionLibrary.html'
  scope:
    lecture: '='
    keyPoints: '='
    categoryId: '='

.controller 'QuestionLibraryCtrl', (
  $scope
  $state
  $modal
  $rootScope
  Restangular
) ->

  angular.extend $scope,
    questions: null
    selectedKeyPoints: []
    keyword: ''
    $state: $state

    # TODO refactor filter
    # correct answers to 'ABC'
    getCorrectInfo: (question) ->
      info = _.reduce question.choices, (result, option, index) ->
        if option.correct==true
          result += String.fromCharCode(65+index)
        result
      , ''
      if info == '' then '?' else info

    getSelectedNum: ->
      _.reduce $scope.questions, (sum, q) ->
        sum + (if q.$selected then 1 else 0)
      , 0

    toggleSelectAll: (selected) ->
      angular.forEach $scope.questions, (q) -> q.$selected = selected if !q.$exists

    toggleKeyPoint: (keyPoint) ->
      keyPoint.$selected = !keyPoint.$selected
      $scope.selectedKeyPoints = _.filter $scope.keyPoints, (k) -> k.$selected
      $scope.searchQuestions()

    removeQuestion: (question = null) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除题库中的问题'
          message: ->
            if question?
              """确认要删除题库中的问题？"""
            else
              """确认要删除题库中的这#{$scope.getSelectedNum()}个问题？"""
      .result.then ->
        questions = $scope.questions
        $scope.selectedAll = false if $scope.selectedAll
        deleteQuestions =
          if question?
            [question]
          else
            _.filter questions, (q) -> q.$selected == true
        $scope.deleting = true
        Restangular.all('questions').customPOST(ids: _.pluck(deleteQuestions, '_id'), 'multiDelete')
        .then ->
          $scope.deleting = false
          angular.forEach deleteQuestions, (q) ->
            questions.splice(questions.indexOf(q), 1)

    addNewQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/newQuestion.html'
        controller: 'NewQuestionCtrl'
        backdrop: 'static'
        resolve:
          keyPoints: -> $scope.keyPoints
          categoryId: -> $scope.categoryId
      .result.then (question) ->
        Restangular.all('questions').post(question)
        .then (newQuestion) ->
          $scope.questions.push newQuestion

    addToLecture: ->
      $scope.updating = true

      $rootScope.$broadcast 'add-library-question', $state.params.questionType,
        _.filter $scope.questions, (q) -> q.$selected

    searchQuestions: ->
      Restangular.all('questions').getList(
        categoryId: $scope.categoryId
        keyword: $scope.keyword
        keyPointIds: JSON.stringify _.pluck($scope.selectedKeyPoints, '_id')
      ).then (questions) ->
        currentQuestions = _.pluck $scope.lecture?[$state.params.questionType], '_id'
        angular.forEach questions, (q) ->
          q.$exists = currentQuestions.indexOf(q._id) >= 0
        $scope.questions = questions

  $scope.searchQuestions()

