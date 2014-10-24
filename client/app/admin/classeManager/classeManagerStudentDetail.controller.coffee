'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerStudentDetailCtrl', (
  $state
  $scope
  $modal
  notify
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
    errors: null
    student: null
    editingInfo: null
    viewState:
      saved: true
      saving: false
      deleting: false

    onAvatarUploaded: (key) ->
      $scope.editingInfo.avatar = key
      $scope.student.patch avatar: key
      .then (newUser) ->
        angular.extend $scope.student, newUser
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.viewState.saving = true
      $scope.student.patch($scope.editingInfo)
      .then (newUser) ->
        $scope.viewState.saving = false
        angular.extend $scope.student, newUser
        $scope.reloadStudents()
        notify
          message: '基本信息已保存'
          classes: 'alert-success'
      .catch (error) ->
        $scope.viewState.saving = false
        $scope.errors = error?.data?.errors

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
        $scope.viewState.deleting = true
        student.remove().then ->
          $scope.viewState.deleting = false
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
    $scope.viewState.saved = isEqual
