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
  CurrentUser
) ->

  angular.extend $scope,

    selectedClasse: undefined
    editingClasse: undefined

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

    loadStudents: ()->
      $scope.selectedClasse.all('students').getList().then (students) ->
        console.log students
        $scope.selectedClasse.$students = students

    deleteClasse: (classe) ->
      classe.remove().then ->
        classes = $scope.classesQ.$object
        index = _.indexOf(classes, classe)
        classes.splice(index, 1)
        $state.go('admin.classeManager')

  console.log CurrentUser

  $scope.classesQ.then ->
    $scope.selectedClasse = _.find($scope.classesQ.$object, _id:$state.params.classeId) ? {}
    $scope.editingClasse = Restangular.copy($scope.selectedClasse)
    return if !$scope.selectedClasse._id
    $scope.loadStudents()


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
        Restangular.one('users').post 'bulk', {key:key,orgId:CurrentUser.orgId,type:'student',classeId:$scope.selectedClasse._id}
        .then (result)->
          console.log result
          $scope.loadStudents()
          $scope.isExcelProcessing = false
        , (error)->
          console.log error
          $scope.isExcelProcessing = false
      fail: (error)->
        notify(error)
        $scope.isExcelProcessing = false
      progress: (speed, percentage, evt)->
        notify($scope.uploadingP)
