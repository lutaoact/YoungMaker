'use strict'

angular.module('mauiApp')

.directive 'editUserTile', ->
  restrict: 'EA'
  replace: true
  controller: 'EditUserTileCtrl'
  templateUrl: 'app/user/userSettings/editUserTile.html'
  scope:
    user: '='
    onUpdateUser: '&'

.controller 'EditUserTileCtrl', (
  $state
  $scope
  $modal
  notify
  Restangular
) ->

  # 能被编辑的字段
  editableFields = [
    'name'
    'email'
    'avatar'
    'info'
  ]

  angular.extend $scope,
    $state: $state
    errors: null
    editingInfo: _.pick $scope.user, editableFields
    viewState:
      saved: true
      saving: false
      deleting: false

    onAvatarUploaded: (key) ->
      $scope.editingInfo.avatar = key
      Restangular.one('users', $scope.user._id)
      .patch avatar: key
      .then ->
        $scope.user.avatar = key
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.viewState.saving = true
      $scope.errors = null
      Restangular.one('users', $scope.user._id)
      .patch($scope.editingInfo)
      .then ->
        $scope.viewState.saving = false
        angular.extend $scope.user, $scope.editingInfo
        notify
          message: '基本信息已保存'
          classes: 'alert-success'
        $scope.onUpdateUser?()
      .catch (error) ->
        $scope.viewState.saving = false
        $scope.errors = error?.data?.errors
        angular.forEach error?.data?.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false

  # 检查正在编辑的信息 是否 等于已经保存好的信息，并设置 viewState
  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.user, editableFields)
  , (isEqual) ->
    $scope.errors = null
    $scope.viewState.saved = isEqual
