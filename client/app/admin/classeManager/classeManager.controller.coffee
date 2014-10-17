'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $scope
  Restangular
) ->

  angular.extend $scope,
    classesQ: Restangular.all('classes').getList()

.controller 'ClasseManagerDetailCtrl', (
  $scope
  $state
  notify
  fileUtils
  Restangular
  CurrentUser
) ->

  angular.extend $scope,

    selectedClasse: null
    editingClasse: null

    saveClasse: (classe, form) ->
      if !form.$valid then return
      classe.orgId = CurrentUser.orgId
      if not classe._id
        #create new classe
        Restangular.all('classes').post(classe).then (newClasse)->
          #TODO refactor
          $scope.classesQ.$object.push(newClasse)
          $state.go('admin.classeManager.detail', classeId:newClasse._id)
      else
        #update classe
        classe.put().then (data)->
          angular.extend $scope.selectedClasse, data
          angular.extend $scope.editingClasse, data

    loadStudents: ->
      $scope.selectedClasse.all('students').getList().then (students) ->
        $scope.selectedClasse.$students = students

    deleteClasse: (classe) ->
      classe.remove().then ->
        classes = $scope.classesQ.$object
        index = _.indexOf(classes, classe)
        classes.splice(index, 1)
        $state.go('admin.classeManager')

  $scope.classesQ.then ->
    $scope.selectedClasse = _.find($scope.classesQ.$object,
      _id: $state.params.classeId) ? {}
    $scope.editingClasse = Restangular.copy($scope.selectedClasse)
    return if !$scope.selectedClasse._id
    $scope.loadStudents()


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
