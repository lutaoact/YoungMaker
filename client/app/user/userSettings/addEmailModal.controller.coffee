'use strict'

angular.module('maui.components')

.controller 'AddEmailModalCtrl', (
  $scope
  notify
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    email: null
    password:
      new: ''
      again: ''

    addEmailAccount: (form) ->
      if !form.$valid then return
      if $scope.password.new.length < 6
        notify
          message:'登录密码不能小于6位'
          classes:'alert-danger'
        return
      if $scope.password.new isnt $scope.password.again
        notify
          message:'两次输入的密码不一致'
          classes:'alert-danger'
        return

      Restangular
        .one('users', 'bindEmail')
        .post '',
          email: $scope.email
          password: $scope.password.new
        .then ->
          $modalInstance.close()
          notify
            message:'Email账户添加成功'
            classes:'alert-success'
        .catch (error) ->
          angular.forEach error?.data?.errors, (error, field) ->
            form[field].$setValidity 'mongoose', false
            form[field].errorMessage = error.message
          notify
            message:'Email账户添加失败'
            classes:'alert-danger'

    close: ->
      $modalInstance.dismiss('cancel')
