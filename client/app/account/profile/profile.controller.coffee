'use strict'

angular.module('budweiserApp').controller 'ProfileCtrl',
(
  Auth
  $scope
  notify
  $modal
  Restangular
) ->
  angular.extend $scope,

    patchMe: (field)->
      if not @me
        #post
        notify
          message:'网络错误'
          template:'components/alert/failure.html'
      else
        #put
        patch = {}
        patch[field] = @me[field]
        if patch[field] is @oldMe[field]
          # not changed
          return
        @me.patch(patch)
        .then (data)->
          angular.extend $scope.me, data
          angular.extend $scope.oldMe, data
          notify
            message:'已保存'
            template:'components/alert/success.html'
          $scope.me

    saveProfile: ()->
      if not @me
        #post
        notify
          message:'网络错误'
          template:'components/alert/failure.html'
      else
        #put
        @me.patch
          name: $scope.me.name
          email: $scope.me.email
        .then (data)->
          angular.extend $scope.me, data
          angular.extend $scope.oldMe, data
          notify
            message:'已保存'
            template:'components/alert/success.html'
          $scope.me

    onAvatarUploaded: ($data)->
      # file is uploaded successfully
      $scope.me.avatar = $data
      $scope.patchMe('avatar')
      .then (user)->
        Auth.getCurrentUser().avatar = user.avatar

    errors: {}

    changePassword: (form) ->
      $scope.submitted = true

      if form.$valid
        if $scope.user.newPassword.length < 6
          notify
            message:'新密码不能小于6位'
            template:'components/alert/failure.html'
          return
        if $scope.user.newPassword isnt $scope.user.newPasswordAgain
          notify
            message:'两次输入的密码不一致'
            template:'components/alert/failure.html'
          return
        Auth.changePassword($scope.user.oldPassword, $scope.user.newPassword).then(->
          notify
            message:'密码修改成功'
            template:'components/alert/success.html'
            $scope.user = {}
        ).catch ->
          notify
            message:'原密码错误'
            template:'components/alert/failure.html'


