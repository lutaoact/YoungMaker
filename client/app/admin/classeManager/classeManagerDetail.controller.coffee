'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerDetailCtrl', (
  Auth
  $scope
  $state
  notify
  $modal
  fileUtils
  Restangular
) ->

  updateSelected = ->
    $scope.selectedStudents =  _.filter($scope.selectedClasse.$students, '$selected':true)

  angular.extend $scope,

    toggleSelectAllStudents: false
    editingClasseName: ''
    selectedStudents: []
    deleting: false

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

    addNewStudent: ->
      $modal.open
        templateUrl: 'app/admin/classeManager/newUserModal.html'
        controller: 'NewUserModalCtrl'
        resolve:
          userType: -> 'student'
          orgUniqueName: -> Auth.getCurrentUser().orgId.uniqueName
      .result.then (newStudent) ->
        newStudents = _.union $scope.selectedClasse.students, [newStudent._id]
        $scope.selectedClasse.patch students:newStudents
        .then ->
          $scope.loadStudents()
          notify
            message: '新学生添加成功'
            classes: 'alert-success'

    loadStudents: ->
      $scope.selectedClasse?.all('students').getList().then (students) ->
        $scope.selectedClasse.students = _.pluck students, '_id'
        $scope.selectedClasse.$students = students
        updateSelected()

    toggleSelect: (students, selected) ->
      angular.forEach students, (s) -> s.$selected = selected
      updateSelected()

    deleteStudents: (students) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除学生'
          message: ->
            """确认要删除这#{students.length}个学生？"""
      .result.then ->
        $scope.toggledSelectAllStudents = false if $scope.toggledSelectAllStudents
        $scope.deleting = true
        Restangular.all('users').customPOST(ids: _.pluck(students, '_id'), 'multiDelete')
        .then ->
          newStudents = _.difference($scope.selectedClasse.$students, students)
          $scope.selectedClasse.patch
            students: _.pluck newStudents, '_id'
          .then ->
            $scope.loadStudents()
            $scope.deleting = false

  $scope.selectedClasse = _.find($scope.classes, _id: $state.params.classeId)
  $scope.editingClasseName = $scope.selectedClasse?.name
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
          orgId: Auth.getCurrentUser().orgId
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
