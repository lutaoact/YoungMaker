'use strict'

angular.module('budweiserApp')

.directive 'teacherLectureKeypoints', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherLectureKeypointsCtrl'
  templateUrl: 'app/teacher/teacherLecture/teacherLecture.keyPoints.html'
  scope:
    lecture: '='
    mediaApi: '='
    keyPoints: '='

.controller 'TeacherLectureKeypointsCtrl', (
  $scope
) ->

  angular.extend $scope,

    seekPlayerTime: (time) ->
      $scope.mediaApi.seekTime time

    keyPointFormatter: ($model) -> $model?.name

    addkeyPoint: (keyPoint) ->
      $scope.lecture.keyPoints.push
        kp : keyPoint
        timestamp: 0
      $scope.savekeyPoints()

    removekeyPoint: (index) ->
      $scope.lecture.keyPoints.splice(index, 1)
      $scope.savekeyPoints()

    updatekeyPoint: (keyPoint) ->
      currentTime = $scope.mediaApi.videoElement?[0]?.currentTime
      keyPoint.timestamp = Math.ceil(currentTime)
      $scope.savekeyPoints()

    savekeyPoints: ->
      newkeyPoints = _.map $scope.lecture.keyPoints, (keyPoint) ->
        kp: keyPoint.kp._id
        timestamp: keyPoint.timestamp
      $scope.lecture.patch?(keyPoints:newkeyPoints)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v


