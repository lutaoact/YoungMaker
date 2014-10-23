'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerDetailCtrl', (
  $scope
  $state
  notify
) ->

  editingKeys = [
    'name'
  ]

  angular.extend $scope,

    eidtingInfo: null
    saved: false

    saveClasse: (form) ->
      if !form.$valid  || $scope.saved then return
      $scope.selectedClasse.patch $scope.editingInfo
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

  $scope.$parent.selectedClasse = _.find($scope.classes, _id:$state.params.classeId)
  $scope.editingInfo = _.pick $scope.selectedClasse, editingKeys
  $scope.reloadStudents()

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.selectedClasse, editingKeys)
  , (isEqual) ->
    $scope.saved = isEqual
