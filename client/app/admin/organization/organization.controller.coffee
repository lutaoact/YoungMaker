'use strict'

angular.module('budweiserApp').controller 'OrganizationCtrl', ($scope,$http,$upload,Restangular) ->
  $scope.message = 'Hello'
  $scope.organization = {}

  $scope.isUploading = false
  $scope.logoPreviewUrl = null
  $scope.onFileSelect = (files)->
    if not files? or files.length < 1
      return
    #TODO: check file type by name or file type. pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
    if not /^.*\.(png|PNG|jpg|JPG|jpeg|JPEG|gif|GIF|bmp|BMP)$/.test files[0].name
      $scope.invalid = true
      return
    if files[0].size > 2 * 1024 * 1024
      $scope.invalid = true
      return

    $scope.isUploading = true
    file = files[0]
    # get upload token
    console.log file
    $http.get('/api/qiniu/uptoken')
    .success (uploadToken)->
      qiniuParam =
        'key': uploadToken.random + '/' + encodeURIComponent(file.name)
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
        logoStyle = '?imageView2/2/w/140/h/40'
        $scope.organization.logo = data.key + logoStyle
        $http.get('api/qiniu/signedUrl/' + encodeURIComponent(data.key + logoStyle))
        .success (url)->
          $scope.logoPreviewUrl = url
        $scope.isUploading = false
      .error (response)->
        console.log response

  $scope.saveOrg = (org)->
    if not org._id
      #post
      Restangular.all('organizations').post(org)
      console.log org


