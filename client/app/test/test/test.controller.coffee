'use strict'

angular.module('budweiserApp').controller 'TestCtrl', ($scope, $http, User, $cookieStore,$localStorage,Restangular,$upload) ->
  $scope.$storage = $localStorage;
  if not $scope.$storage.request
    $scope.$storage.request = {
      method:'GET'
    }
  $scope.token = 'empty'
  $scope.login = (email, password)->
    $http.post('/auth/local',
      email: email
      password: password
    ).success((data) ->
      $cookieStore.put 'token', data.token
      $scope.token = data.token
      currentUser = User.get()
    ).error ((err) ->
      console.log err
    )
  $scope.logout = ()->
    $cookieStore.remove 'token'
    $scope.token = 'empty'
  $scope.response = {}

  $scope.send = ()->
    console.log $scope.$storage.request
    if not $scope.$storage.request.url
      $scope.response = 'url required'
      return
    if $scope.$storage.request.data
      try
        angular.fromJson($scope.$storage.request.data)
      catch error
        $scope.response = error
        return
    $http(
      url:$scope.$storage.request.url
      method:$scope.$storage.request.method
      data:$scope.$storage.request.data
      ).success (data)->
        $scope.response = data
      .error (err)->
        $scope.response = err

  $scope.organizations = []

  Restangular.all('organizations').getList()
  .then (organizations)->
    $scope.organizations = organizations

  $scope.reloadUsers = ()->
    $http.get('/api/users').success (users) ->
      $scope.users = users

  $scope.reloadUsers()

  $scope.isExcelProcessing = false
  $scope.orgId = null
  $scope.onFileSelect = (files)->
    console.log $scope.orgId
    if not files? or files.length < 1
      return
    #TODO: check file type by name or file type. pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
    if not /^.*\.(xls|XLS|xlsx|XLSX)$/.test files[0].name
      $scope.invalid = true
      return
    if files[0].size > 50 * 1024 * 1024
      $scope.invalid = true
      return
    if not $scope.orgId
      return
    $scope.isExcelProcessing = true
    file = files[0]
    # get upload token
    console.log file
    $http.get('/api/qiniu/uptoken')
    .success (uploadToken)->
      qiniuParam =
        'key': uploadToken.random + '/' + ['1', file.name.split('.').pop()].join('.')
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
        $scope.excelUrl = data.key
        $http.post('/api/users/bulk',{key:data.key,orgId:$scope.orgId,type:'teacher'})
        .success (result)->
          console.log result
          $scope.reloadUsers()
        .error (error)->
          console.log error
        .finally ()->
          $scope.isExcelProcessing = false
      .error (response)->
        console.log response



