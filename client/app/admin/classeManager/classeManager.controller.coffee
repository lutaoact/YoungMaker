'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $q
  $modal
  $state
  $scope
  notify
  Classes
  Restangular
) ->

  updateSelected = ->
    $scope.selectedClasses =  _.filter(Classes, '$selected':true)

  angular.extend $scope,
    selectedClasse: null
    selectedClasses: []
    selectedAllClass: false
    classes: Classes

    deleteClasses: (selectedClasses) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除班级'
          message: ->
            """确认要删除这#{selectedClasses.length}个班级？"""
      .result.then ->
        $scope.selectedAllClasse = false if $scope.selectedAllClasse
        $scope.deleting = true
        Restangular.all('classes').customPOST(ids: _.pluck(selectedClasses, '_id'), 'multiDelete')
        .then ->
          $scope.deleting = false
          angular.forEach selectedClasses, (c) ->
            $scope.classes.splice($scope.classes.indexOf(c), 1)
          $state.go('admin.classeManager') if $scope.classes.indexOf($scope.selectedClasse) == -1

    createNewClasse: ->
      $modal.open
        templateUrl: 'app/admin/classeManager/newClasseModal.html'
        controller: 'NewClasseCtrl'
        size: 'sm'
      .result.then (newClasse) ->
        $scope.classes.push(newClasse)
        $state.go('admin.classeManager.detail', classeId:newClasse._id)
        notify
          message: '新班级添加成功'
          classes: 'alert-success'

    toggleSelect: (classes, selected) ->
      angular.forEach classes, (c) -> c.$selected = selected
      updateSelected()
      console.debug $scope.selectedClasses, selected

  $scope.$watch 'classes.length', updateSelected

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    if toState.name == 'admin.classeManager' && Classes.length > 0
      $state.go('admin.classeManager.detail', classeId:Classes[0]._id)

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
