'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerStudentDetailCtrl', (
  $state
  $scope
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
    classe: _.find(Classes, _id: $state.params.classeId)
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
        notify
          message: '基本信息已保存'
          classes: 'alert-success'

  Restangular.one('users', $state.params.studentId).get()
  .then (student) ->
    $scope.student = student
    $scope.editingInfo = _.pick $scope.student, editingKeys

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.student, editingKeys)
  , (isEqual) ->
    $scope.saved = isEqual
