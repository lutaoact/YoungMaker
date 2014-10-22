'use strict'

angular.module('budweiserApp').controller 'TeacherManagerCtrl', (
  Auth
  $modal
  $scope
  notify
  fileUtils
  Restangular
) ->

  reloadTeachers = ->
    Restangular.all('users').getList(role:'teacher')
    .then (teachers) ->
      $scope.teachers = teachers

  angular.extend $scope,

    teachers: null

    deleteTeacher: (teacher) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除老师'
          message: ->
            """确认要删除这个老师生？"""
      .result.then ->
        teacher.remove().then reloadTeachers

    addNewTeacher: ->
      $modal.open
        templateUrl: 'app/admin/newUserModal.html'
        controller: 'NewUserModalCtrl'
        resolve:
          userRole: -> 'teacher'
          orgUniqueName: -> Auth.getCurrentUser().orgId.uniqueName
      .result.then ->
        reloadTeachers()
        notify
          message: '新老师添加成功'
          classes: 'alert-success'

  reloadTeachers()

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
        Restangular.all('users').customPOST
          key: key
          type: 'teacher'
        , 'bulk'
        .then ->
          reLoadTeachers()
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

