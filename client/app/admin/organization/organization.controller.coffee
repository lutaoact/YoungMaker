'use strict'

angular.module('budweiserApp').controller 'OrganizationCtrl', ($scope,$http,$upload,Restangular,Auth) ->
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
        'key': uploadToken.random + '/' + ['logo', file.name.split('.').pop()].join('.')
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
        logoStyle ='?imageView2/2/w/140/h/40'
        $scope.organization.logo = data.key + logoStyle
        $http.get('api/qiniu/signedUrl/' + encodeURIComponent($scope.organization.logo))
        .success (url)->
          $scope.logoPreviewUrl = url
        $scope.isUploading = false
      .error (response)->
        console.log response

  $scope.validateRemote = (subDomain, form)->
    if subDomain is 'tsinghua'
      form.domain.$setValidity 'duplicated', false
    else
      form.domain.$setValidity 'duplicated', true

  $scope.saveOrg = (org,form)->
    if form.$valid
      if not org._id
        #post
        Restangular.all('organizations').post(org)
        .then (data)->
          me = Auth.getCurrentUser()
          $http.get('api/users/' + me._id)
          .success (user)->
            console.log user
          .error (err)->
            console.log err
          console.log org
      else
        #put
        org.put()

  if Auth.getCurrentUser().orgId
    Restangular.one('organizations',Auth.getCurrentUser().orgId).get()
    .then (org)->
      $scope.organization = org
      $http.get('api/qiniu/signedUrl/' + encodeURIComponent(org.logo))
        .success (url)->
          $scope.logoPreviewUrl = url


