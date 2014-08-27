'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $scope,
  Restangular) ->

  angular.extend $scope,
    classesQ: Restangular.all('classes').getList()

.controller 'ClasseManagerDetailCtrl',
(
  Auth
  $scope
  $state
  $http
  Restangular
  qiniuUtils
  notify
) ->

  angular.extend $scope,

    selectedClasse: undefined
    editingClasse: undefined

    saveClasse: (classe, form) ->
      if !form.$valid then return
      classe.orgId = Auth.getCurrentUser().orgId
      if not classe._id
        #create new classe
        Restangular.all('classes').post(classe).then (newClasse)->
          #TODO refactor
          $scope.classesQ.$object.push(newClasse)
          $state.go('admin.classeManager.detail', classeId:newClasse._id)
      else
        #update classe
        classe.put().then ->
          angular.extend $scope.selectedClasse, classe

    deleteClasse: (classe) ->
      classe.remove().then ->
        classes = $scope.classesQ.$object
        index = _.indexOf(classes, classe)
        classes.splice(index, 1)
        $state.go('admin.classeManager')


  $scope.classesQ.then ->
    $scope.selectedClasse = _.find($scope.classesQ.$object, _id:$state.params.classeId) ? {}
    $scope.editingClasse = Restangular.copy($scope.selectedClasse)
    if !$scope.selectedClasse._id || $scope.selectedClasse.students then return
    $scope.selectedClasse.all('students').getList().then (students) ->
      $scope.selectedClasse.students = students


  #TODO refactor
  $scope.isExcelProcessing = false

  $scope.onFileSelect = (files)->
    $scope.isExcelProcessing = true
    qiniuUtils.uploadFile
      files: files
      validation:
        max: 50 * 1024 * 1024
        accept: 'excel'
      success: (key)->
        $scope.excelUrl = key
        Restangular.one('users','bulk').post {key:$scope.excelUrl,orgId:Auth.getCurrentUser().orgId,type:'student',classeId:$scope.classe._id}
        .then (result)->
          console.log result
          $scope.reloadStudents()
          $scope.isExcelProcessing = false
        , (error)->
          console.log error
          $scope.isExcelProcessing = false
      fail: (error)->
        notify(error)
        $scope.isExcelProcessing = false
      progress: (speed, percentage, evt)->
        notify($scope.uploadingP)
