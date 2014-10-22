'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerDetailCtrl', (
  $scope
  $state
  notify
) ->

  angular.extend $scope,

    editingClasseName: ''

    saveClasse: (form) ->
      if !form.$valid then return
      if $scope.editingClasseName != $scope.selectedClasse.name
        $scope.selectedClasse.patch
          name: $scope.editingClasseName
          students: $scope.selectedClasse.students
        .then (classe)->
          angular.extend $scope.selectedClasse, classe
          notify
            message: """"#{classe.name}"信息已保存"""
            classes: 'alert-success'

    reloadStudents: ->
      $scope.selectedClasse?.all('students').getList()
      .then (students) ->
        $scope.selectedClasse.students = _.pluck students, '_id'
        $scope.selectedClasse.$students = students

    viewStudent: (student) ->
      $state.go('admin.classeManager.detail.student', classeId:$scope.selectedClasse._id, studentId:student._id)

  $scope.selectedClasse = _.find($scope.classes, _id: $state.params.classeId)
  $scope.editingClasseName = $scope.selectedClasse?.name
  $scope.reloadStudents() if $scope.selectedClasse?._id
