'use strict'

angular.module('budweiserApp')

.directive 'editLectureKeyPoints', ->
  restrict: 'EA'
  replace: true
  controller: 'EditLectureKeyPointsCtrl'
  templateUrl: 'app/teacher/teacherLecture/editLectureKeyPoints.html'
  scope:
    lecture: '='
    mediaApi: '='
    keyPoints: '='
    categoryId: '='

.controller 'EditLectureKeyPointsCtrl', (
  $scope
) ->

  angular.extend $scope,

    addKeyPoint: ->
      currentTime = $scope.mediaApi.videoElement?[0]?.currentTime
      newKeyPoint =
        timestamp: Math.ceil(currentTime)
      $scope.lecture.keyPoints.push newKeyPoint
      $scope.saveKeyPoints()
      $scope.mediaApi.playPause()

    removeKeyPoint: (keyPoint) ->
      keyPoints = $scope.lecture.keyPoints
      index = keyPoints.indexOf(keyPoint)
      keyPoints.splice(index, 1)
      $scope.saveKeyPoints()

    setKeyPointTime: (keyPoint) ->
      currentTime = $scope.mediaApi.videoElement?[0]?.currentTime
      keyPoint.timestamp = Math.ceil(currentTime)
      $scope.saveKeyPoints()

    setKeyPointKp: (keyPoint, kp, input) ->
      if kp?
        keyPoint.kp = kp
        $scope.saveKeyPoints()
        return
      if input?
        $scope.keyPoints.post
          name: input
          categoryId: $scope.categoryId
        .then (newKp) ->
          $scope.keyPoints.push newKp
          keyPoint.kp = newKp
          $scope.saveKeyPoints()

    saveKeyPoints: ->
      newkeyPoints = _.map $scope.lecture.keyPoints, (keyPoint) ->
        kp: keyPoint.kp?._id
        timestamp: keyPoint.timestamp
      $scope.lecture.patch?(keyPoints:newkeyPoints)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v


