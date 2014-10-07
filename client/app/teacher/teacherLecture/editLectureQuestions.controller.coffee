'use strict'

angular.module('budweiserApp')
.value('$anchorScroll', angular.noop)
.directive 'editLectureQuestions', ->
  restrict: 'EA'
  replace: true
  controller: 'EditLectureQuestionsCtrl'
  templateUrl: 'app/teacher/teacherLecture/editLectureQuestions.html'
  scope:
    lecture: '='
    categoryId: '='
    keyPoints: '='

.controller 'EditLectureQuestionsCtrl', (
  $scope
  $state
  $modal
  $timeout
  $document
  Restangular
) ->

  questionType = 'quizzes' # quizzes | homeworks

  angular.extend $scope,
    selectedAll: false
    deleting: false
    quizzesActive: true

    setQuestionType: (type) ->
      questionType = type
      $scope.quizzesActive = type == 'quizzes'

    getQuestions: ->
      $scope.lecture?[questionType]

    addLibraryQuestion: ->
      $state.go('teacher.lecture.questionLibrary', {
        courseId: $state.params.courseId
        lectureId: $state.params.lectureId
        questionType: questionType
      })

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
          addQuestions [newQuestion]

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
        deleteQuestions =
          if question?
            [ question ]
          else
            $scope.selectedAll = false if $scope.selectedAll
            deleteQuestions = _.filter questions, (q) -> q.$selected == true
        angular.forEach deleteQuestions, (q) -> questions.splice(questions.indexOf(q), 1)
        $scope.deleting = true
        saveQuestions(questions)

  addQuestions = (newQuesions) ->
    questions = $scope.getQuestions()
    angular.forEach newQuesions, (q) -> questions.push q
    saveQuestions(questions)

  saveQuestions = (questions) ->
    patch = {}
    patch[questionType] = _.map questions, (q) -> q._id
    if $scope.lecture.patch?
      $scope.lecture.patch(patch)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v
        backToLecture()
    else
      _.delay backToLecture, 300

  backToLecture = ->
    $scope.deleting = false
    $state.go('teacher.lecture', {
      courseId: $state.params.courseId
      lectureId: $state.params.lectureId
    })

  $scope.$on 'add-library-question', (event, type, questions) ->
    $scope.setQuestionType(type)
    addQuestions questions
    finish = $scope.$on '$stateChangeSuccess', -> $timeout ->
      finish()
      targetElement = angular.element(document.getElementById 'lecture-question')
      $document.scrollToElement(targetElement, 60, 500)

