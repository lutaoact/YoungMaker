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

    saveNote: ()->
      if $scope.note?._id
        $scope.note.patch note: $scope.note.note
        .then (note)->
          angular.extend $scope.note, note
      else
        $scope.note.lectureId = $state.params.lectureId
        Restangular.all('user_lecture_notes').post $scope.note
        .then (note)->
          angular.extend $scope.note, note

  Restangular.all('user_lecture_notes').getList
    lectureId: $state.params.lectureId
  .then (note)->
    if note?.length
      console.log note[0]
      $scope.note = note[0]
    else
      $scope.note = {}


