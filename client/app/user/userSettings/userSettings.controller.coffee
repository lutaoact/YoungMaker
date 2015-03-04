'use strict'

angular.module('mauiApp')

.controller 'UserSettingsCtrl',(
  Auth
  $state
  $scope
  $modal
  notify
  Restangular
) ->

  $scope.$emit 'updateTitle', '账户设置'

  # 能被编辑的字段
  editableFields = [
    'name'
    'avatar'
    'info'
  ]

  angular.extend $scope,
    $state: $state
    errors: null
    editingInfo: _.pick $scope.me, editableFields
    viewState:
      saved: true
      saving: false
      deleting: false

    onAvatarUploaded: (key) ->
      $scope.editingInfo.avatar = key
      Restangular.one('users', $scope.me._id)
      .patch avatar: key
      .then ->
        $scope.me.avatar = key
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.viewState.saving = true
      $scope.errors = null
      Restangular.one('users', $scope.me._id)
      .patch($scope.editingInfo)
      .then ->
        $scope.viewState.saving = false
        angular.extend $scope.me, $scope.editingInfo
        notify
          message: '基本信息已保存'
          classes: 'alert-success'
        $scope.onUpdateUser?()
      .catch (error) ->
        notify
          message: '保存失败'
          classes: 'alert-danger'
        $scope.viewState.saving = false
        $scope.errors = error?.data?.errors
        angular.forEach error?.data?.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false

    addWeixinLogin: ->
      $modal.open
        templateUrl: 'app/user/userSettings/addWeixinModal.html'
        windowClass: 'message-modal'
        controller: 'AddWeixinModalCtrl'
        size: 'sm'

    changePassword: ->
      $modal.open
        templateUrl: 'app/user/userSettings/changePasswordModal.html'
        windowClass: 'message-modal'
        controller: 'ChangePasswordModalCtrl'
        size: 'sm'

    addEmailAccount: ->
      $modal.open
        templateUrl: 'app/user/userSettings/addEmailModal.html'
        windowClass: 'message-modal'
        controller: 'AddEmailModalCtrl'
        size: 'sm'
      .result.then ->
        Auth.refreshCurrentUser()

  # 检查正在编辑的信息 是否 等于已经保存好的信息，并设置 viewState
  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.me, editableFields)
  , (isEqual) ->
    $scope.errors = null
    $scope.viewState.saved = isEqual
