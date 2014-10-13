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
  $tools
) ->

  saveKeyPoints = ->
    newkeyPoints = _.map $scope.lecture.keyPoints, (keyPoint) ->
      kp: keyPoint.kp?._id
      timestamp: keyPoint.timestamp
    $scope.lecture.patch?(keyPoints:newkeyPoints)
    .then (newLecture) ->
      $scope.lecture.__v = newLecture.__v

  angular.extend $scope,

    seconds2TimeStrings: $tools.seconds2TimeStrings

    seekPlayerTime: (time) ->
      $scope.mediaApi.seekTime(time) if time >= 0

    addKeyPoint: ->
      currentTime = $scope.mediaApi.mediaElement?[0]?.currentTime
      newKeyPoint =
        timestamp: Math.ceil(currentTime)
      $scope.lecture.keyPoints.push newKeyPoint
      saveKeyPoints()
      $scope.mediaApi.pause()

    removeKeyPoint: (keyPoint) ->
      keyPoints = $scope.lecture.keyPoints
      index = keyPoints.indexOf(keyPoint)
      keyPoints.splice(index, 1)
      saveKeyPoints()

    updateKeyPointTime: (keyPoint, timeStrings) ->
      keyPoint.timestamp = $tools.timeStrings2Seconds(timeStrings)
      saveKeyPoints()
      $tools.seconds2TimeStrings(keyPoint.timestamp)

    setKeyPointKp: (keyPoint, kp, input) ->
      if kp?
        keyPoint.kp = kp
        saveKeyPoints()
        return
      if input?
        $scope.keyPoints.post
          name: input
          categoryId: $scope.categoryId
        .then (newKp) ->
          $scope.keyPoints.push newKp
          keyPoint.kp = newKp
          saveKeyPoints()



