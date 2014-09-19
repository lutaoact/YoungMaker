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
    keyPoints: Restangular.all('key_points').getList().$object
    lecture: Restangular.one('lectures', $state.params.lectureId).get().$object

    pushQuestion: (quizze) ->
      $modal.open
        templateUrl: 'app/teacher/teacherTeaching/pushQuestion.html'
        controller: 'PushQuestionCtrl'
        resolve:
          classe: -> _.find Classes, _id:$state.params.classeId
          lecture: -> $scope.lecture
          question: -> quizze
          keyPoints: -> $scope.keyPoints
      .result.then ->

  Restangular.all('activities').post
    eventType: Const.Teacher.ViewLecture
    data:
      lectureId: $state.params.lectureId
      courseId: $state.params.courseId
      classeId: $state.params.classeId

