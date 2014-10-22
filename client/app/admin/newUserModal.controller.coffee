'use strict'

angular.module('budweiserApp').controller 'NewUserModalCtrl', (
  $scope
  notify
  userRole
  Restangular
  orgUniqueName
  $modalInstance
) ->

  angular.extend $scope,

    errors: null
    orgUniqueName: orgUniqueName

    user:
      role: userRole
      username: ''

    title:
      switch userRole
        when 'student' then '添加新学生'
        when 'teacher' then '添加新老师'
        when 'admin'   then '添加新管理员'
        else throw "unknown user.role #{userRole}"

    cancel: ->
      $modalInstance.dismiss('cancel')

    onAvatarUploaded: (key) ->
      $scope.user.avatar = key

    confirm: (form) ->
      if !form.$valid then return
      newUser = angular.copy $scope.user
      newUser.username += '_' + orgUniqueName
      Restangular.all('users').post newUser
      .then $modalInstance.close, (error) ->
        $scope.errors = error?.data?.errors

