'use strict'

angular.module('budweiserApp').controller 'TeacherTeachingCtrl', (
  $scope
  $state
  $modal
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
          question: -> quizze
          keyPoints: -> $scope.keyPoints
      .result.then ->
        console.debug 'push question', quizze
        Restangular.all('questions').customPOST null, 'quiz',
          questionId: quizze._id
          classId: $state.params.classeId

