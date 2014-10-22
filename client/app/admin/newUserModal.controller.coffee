'use strict'

angular.module('budweiserApp').controller 'NewUserModalCtrl', (
  $scope
  notify
  userType
  Restangular
  orgUniqueName
  $modalInstance
) ->

  angular.extend $scope,

    errors: null
    orgUniqueName: orgUniqueName

    user:
      type: userType
      username: ''

    title:
      switch userType
        when 'student' then '添加新学生'
        when 'teacher' then '添加新老师'
        when 'admin'   then '添加新管理员'
        else throw "unknown usertype #{userType}"

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

