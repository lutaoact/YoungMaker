'use strict'

angular.module('maui.components')

.controller 'ChangePasswordModalCtrl', (
  $scope
  notify
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    password:
      old: ''
      new: ''
      again: ''

    changePassword: (form) ->
      if !form.$valid then return
      if $scope.password.new.length < 6
        notify
          message:'新密码不能小于6位'
          classes:'alert-danger'
        return
      if $scope.password.new isnt $scope.password.again
        notify
          message:'两次输入的密码不一致'
          classes:'alert-danger'
        return

      Restangular
        .one('users', 'changePassword')
        .post '',
          oldPassword: $scope.password.old
          newPassword: $scope.password.new
        .then ->
          $modalInstance.close()
          notify
            message:'密码修改成功'
            classes:'alert-success'
        .catch ->
          notify
            message:'原密码错误'
            classes:'alert-danger'

    close: (code) ->
      $modalInstance.dismiss('cancel')
