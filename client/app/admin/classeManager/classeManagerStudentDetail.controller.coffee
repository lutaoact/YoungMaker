'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerStudentDetailCtrl', (
  $state
  $scope
  $modal
  notify
  Classes
  Restangular
) ->

  editingKeys = [
    'name'
    'email'
    'avatar'
    'info'
  ]

  angular.extend $scope,
    $state: $state
    student: null
    saving: false
    saved: true

    onAvatarUploaded: (key) ->
      $scope.student.avatar = key
      $scope.student.patch avatar: key
      .then ->
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.saving = true
      $scope.student.patch($scope.editingInfo).then ->
        angular.extend $scope.student, $scope.editingInfo
        $scope.saving = false
        $scope.reloadStudents()
        notify
          message: '基本信息已保存'
          classes: 'alert-success'

    removeStudent: (student) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        size: 'sm'
        resolve:
          title: -> '删除学生'
          message: ->
            """确认要删除学生"#{student.name}"？"""
      .result.then ->
        student.remove().then ->
          notify
            message: '该学生已被删除'
            classes: 'alert-success'
          $state.go('admin.classeManager.detail', classeId:$state.params.classeId)
          $scope.reloadStudents()

  Restangular.one('users', $state.params.studentId).get()
  .then (student) ->
    $scope.student = student
    $scope.editingInfo = _.pick $scope.student, editingKeys

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.student, editingKeys)
  , (isEqual) ->
    $scope.saved = isEqual
