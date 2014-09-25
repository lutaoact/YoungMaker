'use strict'

angular.module('budweiserApp')

.directive 'teacherLectureQuestions', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherLectureQuestionsCtrl'
  templateUrl: 'app/teacher/teacherLecture/teacherLecture.questions.html'
  scope:
    lecture: '='
    categoryId: '='
    keyPoints: '='
    libraryQuestions: '='

.controller 'TeacherLectureQuestionsCtrl', (
  $scope
  $state
  $modal
  Restangular
) ->

  angular.extend $scope,

    questionType: 'quizzes' # quizzes | homeworks
    selectedAll: false

    getKeyPoint: (id) -> _.find($scope.keyPoints, _id:id)

    setQuestionType: (type) ->
      $scope.questionType = type

    getQuestions: ->
      $scope.lecture?[$scope.questionType]

    getCorrectInfo: (question) ->
      _.reduce question.content.body, (result, option, index) ->
        if option.correct==true
          result += String.fromCharCode(65+index)
        result
      , ''

    addLibraryQuestion: ->
      $state.go('teacher.questionLibrary', {
        courseId: $state.params.courseId
        lectureId: $state.params.lectureId
        questionType: $scope.questionType
      })

    addNewQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/newQuestion.html'
        controller: 'NewQuestionCtrl'
        resolve:
          keyPoints: -> $scope.keyPoints
          categoryId: -> $scope.categoryId
      .result.then (question) ->
        Restangular.all('questions').post(question)
        .then (newQuestion) ->
          $scope.libraryQuestions.push newQuestion
          addQuestion(newQuestion)

    getSelectedNum: ->
      _.reduce $scope.getQuestions(), (sum, q) ->
        sum + (if q.$selected then 1 else 0)
      , 0

    toggleSelectAll: (selected) ->
      angular.forEach $scope.getQuestions(), (q) -> q.$selected = selected

    removeQuestion: (question = null) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除问题'
          message: ->
            if question?
              """确认要删除"#{question.content.title}"？"""
            else
              """确认要删除这#{$scope.getSelectedNum()}个问题？"""
      .result.then ->
        questions = $scope.getQuestions()
        if question?
          index = questions.indexOf question
          questions.splice index, 1
        else
          $scope.selectedAll = false if $scope.selectedAll
          deleteQuestions = _.filter questions, (q) -> q.$selected == true
          angular.forEach deleteQuestions, (q) ->
            questions.splice(questions.indexOf(q), 1)
        saveQuestions(questions)

  addQuestion = (question) ->
    questions = $scope.getQuestions()
    questions.push question
    saveQuestions(questions)

  saveQuestions = (questions) ->
    patch = {}
    patch[$scope.questionType] = _.map questions, (q) -> q._id
    $scope.lecture.patch?(patch)
    .then (newLecture) ->
      $scope.lecture.__v = newLecture.__v
