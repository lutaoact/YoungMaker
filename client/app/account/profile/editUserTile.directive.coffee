'use strict'

angular.module('mauiApp')

.directive 'editUserTile', ->
  restrict: 'EA'
  replace: true
  controller: 'EditUserTileCtrl'
  templateUrl: 'app/account/profile/editUserTile.html'
  scope:
    user: '='
    canDelete: '@' # 能否删除这个用户 - 管理员需要
    canRemark: '@' # 能否修改用户的备注信息 - 管理员需要
    onUpdateUser: '&'
    onDeleteUser: '&'

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
    editingInfo: null
    viewState:
      saved: true
      saving: false
      deleting: false
    roleTitle: ''

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

    removeUser: (user) ->
      $modal.open
        templateUrl: 'components/modals/message/messageModal.html'
        controller: 'MessageModalCtrl'
        size: 'sm'
        resolve:
          title: -> '删除' + $scope.roleTitle
          message: ->
            """确认要删除#{$scope.roleTitle}"#{user.name}"？"""
      .result.then ->
        $scope.viewState.deleting = true
        Restangular.one('users', user._id)
        .remove()
        .then ->
          $scope.viewState.deleting = false
          notify
            message: "该#{$scope.roleTitle}已被删除"
            classes: 'alert-success'
          $scope.onDeleteUser?()

  $scope.$watch 'user', (user) ->
    if !user? then return
    $scope.user = user
    $scope.editingInfo = _.pick user, editableFields
    $scope.roleTitle =
      switch user.role
        when 'student' then '学生'
        when 'teacher' then '教师'
        when 'admin'   then '管理员'
        else throw 'unknown user.role ' + user.role

  # 检查正在编辑的信息 是否 等于已经保存好的信息，并设置 viewState
  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.user, editableFields)
  , (isEqual) ->
    $scope.errors = null
    $scope.viewState.saved = isEqual
