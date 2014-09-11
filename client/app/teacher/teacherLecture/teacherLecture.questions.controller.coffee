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
  $modal
  Restangular
) ->

  angular.extend $scope,

    questionType: 'quizzes' # quizzes | homeworks

    getKeyPoint: (id) -> _.find($scope.keyPoints, _id:id)

    setQuestionType: (type) ->
      $scope.questionType = type

    getQuestions: ->
      $scope.lecture?[$scope.questionType]

    addLibraryQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/questionLibrary.html'
        controller: 'QuestionLibraryCtrl as ctrl'
        resolve:
          keyPoints: -> $scope.keyPoints
          questions: -> $scope.libraryQuestions
      .result.then addQuestion

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

    removeQuestion: (index) ->
      questions = $scope.getQuestions()
      questions.splice index, 1
      saveQuestions(questions)

    sendQuestion: (question) ->
      Restangular.all('questions').customPOST(null, 'quiz', questionId:question._id, classId:'444444444444444444444400')

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
