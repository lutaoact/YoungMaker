'use strict'

angular.module('budweiserApp').controller 'LectureNotesCtrl',
(
  $scope
  Restangular
  $state
  $localStorage
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,
    note: undefined

  Restangular.one('user_lecture_notes').get
    lectureId: $state.lectureId

  $localStorage[$scope.me._id] ?= {}
  $localStorage[$scope.me._id]['lectures'] ?= {}
  lectureState = $localStorage[$scope.me._id]['lectures'][$state.params.lectureId] ?= {}
  $scope.lectureState = lectureState
