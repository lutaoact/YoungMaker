'use strict'

angular.module('budweiserApp').controller 'TeacherTeachingCtrl', (
  $scope
  $state
  $modal
  Classes
  Restangular
) ->

  angular.extend $scope,

    $state: $state
    currentPage: 0
    currentNum: 1
    showAllPPT: false
    showVideo: false
    lecture: Restangular.one('lectures', $state.params.lectureId).get().$object
    course: Restangular.one('courses', $state.params.courseId).get().$object

    changeCurrentIndex: (index) ->
      $scope.currentIndex = index

    togglePPT: ->
      $scope.showVideo = false
      $scope.showAllPPT = !$scope.showAllPPT

    toggleVideo: ->
      $scope.showAllPPT = false
      $scope.showVideo = !$scope.showVideo

    pushQuestion: (quizze) ->
      $modal.open
        templateUrl: 'app/teacher/teacherTeaching/pushQuestion.html'
        controller: 'PushQuestionCtrl'
        backdrop: 'static'
        resolve:
          classe: -> _.find Classes, _id:$state.params.classeId
          lecture: -> $scope.lecture
          question: -> quizze
      .result.then ->

  $scope.$watch 'currentIndex', ->
    $scope.currentNum = $scope.currentIndex + 1

  Restangular.all('activities').post
    eventType: Const.Teacher.ViewLecture
    data:
      lectureId: $state.params.lectureId
      courseId: $state.params.courseId
      classeId: $state.params.classeId

