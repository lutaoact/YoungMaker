'use strict'

angular.module('budweiserApp').controller 'TeacherTeachingCtrl', (
  $scope
  $state
  $modal
  Classes
  Courses
  Restangular
  $sce
  $timeout
) ->

  # TODO: remove this line. Fix in videogular
  $scope.$on '$destroy', ()->
    # clear video
    angular.element('video').attr 'src', ''

  angular.extend $scope,

    $state: $state
    currentPage: 0
    currentNum: 1
    showAllPPT: false
    showVideo: false
    lecture: undefined
    classe: _.find Classes, _id:$state.params.classeId
    course: _.find Courses, _id:$state.params.courseId

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
          classe: -> $scope.classe
          lecture: -> $scope.lecture
          question: -> quizze
      .result.then ->

    genTooltip: (showMenu) ->
      if !showMenu then '推送随堂练习'

    moving: false
    onMouseMove: ()->
      if not @moving
        $scope.moving = true
        $timeout ->
          angular.element('#controls-container').mousemove()
        $timeout ->
          $scope.moving = false
        , 500

  $scope.$watch 'currentIndex', ->
    $scope.currentNum = $scope.currentIndex + 1

  Restangular.all('activities').post
    eventType: Const.Teacher.ViewLecture
    data:
      lectureId: $state.params.lectureId
      courseId: $state.params.courseId
      classeId: $state.params.classeId

  Restangular.one('lectures', $state.params.lectureId).get()
  .then (lecture)->
    $scope.lecture = lecture
    $scope.lecture.$mediaSource = [
      src: $sce.trustAsResourceUrl(lecture.media)
      type: 'video/mp4'
    ]

