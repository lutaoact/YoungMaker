'use strict'

angular.module('mauiApp')

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