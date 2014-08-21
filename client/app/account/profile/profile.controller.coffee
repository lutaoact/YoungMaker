'use strict'

angular.module('budweiserApp').controller 'ProfileCtrl', ($scope, User, Auth, Restangular,$http,$upload,notify) ->
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
      if not files? or files.length < 1
        return
      #TODO: check file type by name or file type. pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
      if not /^.*\.(png|PNG|jpg|JPG|jpeg|JPEG|gif|GIF|bmp|BMP)$/.test files[0].name
        $scope.invalid = true
        return
      if files[0].size > 5 * 1024 * 1024
        $scope.invalid = true
        return

      $scope.isUploading = true
      file = files[0]
      # get upload token
      console.log file
      $http.get('/api/qiniu/uptoken')
      .success (uploadToken)->
        qiniuParam =
          'key': uploadToken.random + '/' + ['avatar', file.name.split('.').pop()].join('.')
          'token': uploadToken.token
        $scope.upload = $upload.upload
          url: 'http://up.qiniu.com'
          method: 'POST'
          data: qiniuParam
          withCredentials: false
          file: file
          fileFormDataName: 'file'
        .progress (evt)->
          $scope.uploadingP = parseInt(100.0 * evt.loaded / evt.total)
        .success (data) ->
          # file is uploaded successfully
          avatarStyle ='?imageView2/1/w/64/h/64'
          $scope.me.avatar = data.key + avatarStyle
          $scope.patchMe('avatar')
          .then (user)->
            Auth.getCurrentUser().avatar = user.avatar
            $scope.isUploading = false
        .error (response)->
          console.log response

    isUploading: false

  $scope.getMyProfile()




