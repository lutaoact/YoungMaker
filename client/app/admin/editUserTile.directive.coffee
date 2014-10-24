'use strict'

angular.module('budweiserApp')

.directive 'editUserTile', ->
  restrict: 'EA'
  replace: true
  controller: 'EditUserTileCtrl'
  templateUrl: 'app/admin/editUserTile.html'
  scope:
    user: '='
    canDelete: '@'
    infoEditable: '@'
    onUpdateUser: '&'
    onDeleteUser: '&'

.controller 'EditUserTileCtrl', (
  $state
  $scope
  $modal
  notify
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
    editingInfo: null
    viewState:
      saved: true
      saving: false
      deleting: false
    roleTitle: ''

    onAvatarUploaded: (key) ->
      $scope.editingInfo.avatar = key
      $scope.user.patch avatar: key
      .then (newUser) ->
        angular.extend $scope.user, newUser
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.viewState.saving = true
      $scope.user.patch($scope.editingInfo)
      .then (newUser) ->
        $scope.viewState.saving = false
        angular.extend $scope.user, newUser
        notify
          message: '基本信息已保存'
          classes: 'alert-success'
        $scope.onUpdateUser?()
      .catch (error) ->
        $scope.viewState.saving = false
        $scope.errors = error?.data?.errors

    removeUser: (user) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        size: 'sm'
        resolve:
          title: -> '删除' + $scope.roleTitle
          message: ->
            """确认要删除#{$scope.roleTitle}"#{user.name}"？"""
      .result.then ->
        $scope.viewState.deleting = true
        user.remove().then ->
          $scope.viewState.deleting = false
          notify
            message: "该#{$scope.roleTitle}已被删除"
            classes: 'alert-success'
          $scope.onDeleteUser?()

  $scope.$watch 'user', (user) ->
    if !user? then return
    $scope.user = user
    $scope.editingInfo = _.pick user, editingKeys
    $scope.roleTitle =
      switch user.role
        when 'student' then '学生'
        when 'teacher' then '教师'
        when 'admin'   then '管理员'
        else throw 'unknown user.role ' + user.role

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.user, editingKeys)
  , (isEqual) ->
    $scope.viewState.saved = isEqual
