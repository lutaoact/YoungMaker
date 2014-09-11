'use strict'

angular.module('budweiserApp').controller 'ProfileCtrl',
($scope, User, Auth, Restangular,$http,$upload,notify,fileUtils) ->
  angular.extend $scope,

    me: null

    oldMe: null

    getMyProfile: ()->
      Restangular.one('users','me').get()
      .then (user)->
        $scope.me = user
        $scope.oldMe = Restangular.copy(user)

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

    onFileSelect: (files)->
      $scope.isUploading = true
      fileUtils.uploadFile
        files: files
        validation:
          max: 5 * 1024 * 1024
          accept: 'image'
        success: (key)->
          # file is uploaded successfully
          $scope.me.avatar = key
          $scope.patchMe('avatar')
          .then (user)->
            Auth.getCurrentUser().avatar = user.avatar
            $scope.isUploading = false
        fail: (error)->
          $scope.isUploading = false
          console.log error

    isUploading: false

  $scope.getMyProfile()




