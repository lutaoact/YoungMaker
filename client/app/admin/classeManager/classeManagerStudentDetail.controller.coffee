'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerStudentDetailCtrl', (
  $state
  $scope
  Restangular
) ->

  angular.extend $scope,
    $state: $state
    student: null

    updateStudent: ->
      $scope.reloadStudents()

    deleteStudent: ->
      $scope.reloadStudents()
      $state.go('admin.classeManager.detail', classeId:$state.params.classeId)

  Restangular.one('users', $state.params.studentId).get()
  .then (student) ->
    $scope.student = student