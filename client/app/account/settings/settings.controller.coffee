'use strict'

angular.module('budweiserApp').controller 'SettingsCtrl', ($scope, User, Auth, Restangular,$http,$upload) ->
  $scope.errors = {}
  $scope.me = null
  $scope.changePassword = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.changePassword($scope.user.oldPassword, $scope.user.newPassword).then(->
        $scope.message = 'Password successfully changed.'
      ).catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Incorrect password'
        $scope.message = ''

  Restangular.one('users','me').get()
  .then (user)->
    console.log user
    $scope.me = user

  $scope.isUploading = false

  $scope.onFileSelect = (files)->
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
        console.log data
        avatarStyle ='?imageView2/1/w/64/h/64'
        $scope.me.avatar = data.key + avatarStyle
        $scope.me.put()
        .then (user)->
          console.log user
          $scope.isUploading = false
      .error (response)->
        console.log response
