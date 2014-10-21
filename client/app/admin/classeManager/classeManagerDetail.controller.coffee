'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerDetailCtrl', (
  $scope
  $state
  notify
  fileUtils
  Restangular
  CurrentUser
) ->

  angular.extend $scope,

    saveClasse: (form) ->
      if !form.$valid then return
      $scope.selectedClasse.patch(name:$scope.selectedClasse.name).then (classe)->
        angular.extend $scope.selectedClasse, classe
        notify
          message: """"#{classe.name}"信息已保存"""
          classes: 'alert-success'

    loadStudents: ->
      $scope.selectedClasse?.all('students').getList().then (students) ->
        $scope.selectedClasse.$students = students

  $scope.selectedClasse = _.find($scope.classes, _id: $state.params.classeId)
  $scope.loadStudents() if $scope.selectedClasse?._id

  #TODO refactor
  $scope.isExcelProcessing = false

  $scope.onFileSelect = (files)->
    $scope.isExcelProcessing = true
    fileUtils.uploadFile
      files: files
      validation:
        max: 50 * 1024 * 1024
        accept: 'excel'
      success: (key)->
        Restangular.one('users').post 'bulk',
          key: key
          orgId: CurrentUser.orgId
          type: 'student'
          classeId: $scope.selectedClasse._id
        .then ->
          $scope.loadStudents()
          $scope.isExcelProcessing = false
        , (error)->
          console.log error
          $scope.isExcelProcessing = false
      fail: (error)->
        notify
          message: error
          classes: 'alert-danger'
        $scope.isExcelProcessing = false
      progress: ->
        console.debug 'uploading...'
