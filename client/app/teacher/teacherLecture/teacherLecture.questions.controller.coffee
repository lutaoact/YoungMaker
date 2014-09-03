'use strict'

angular.module('budweiserApp')

.directive 'teacherLectureQuestions', ->
  restrict: 'EA'
  transclude: true
  replace: true
  controller: 'TeacherLectureQuestionsCtrl'
  templateUrl: 'app/teacher/teacherLecture/teacherLecture.questions.html'
  scope:
    lecture: '='
    categoryId: '='
    libraryQuestions: '='

.controller 'TeacherLectureQuestionsCtrl', (
  $scope
  $modal
  Restangular
) ->

  angular.extend $scope,

    questionType: 'quizzes' # quizzes | homeworks

    setQuestionType: (type) ->
      $scope.questionType = type

    getQuestions: ->
      $scope.lecture?[$scope.questionType]

    addLibraryQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/questionLibrary.html'
        controller: 'QuestionLibraryCtrl as ctrl'
        resolve:
          questions: -> $scope.libraryQuestions
      .result.then addQuestion

    addNewQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/newQuestion.html'
        controller: 'NewQuestionCtrl'
        resolve:
          categoryId: -> $scope.categoryId
      .result.then (question) ->
        Restangular.all('questions').post(question)
        .then (newQuestion) ->
          $scope.libraryQuestions.push newQuestion
          addQuestion(newQuestion)

    removeQuestion: (index) ->
      questions = $scope.getQuestions()
      questions.splice index, 1
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
