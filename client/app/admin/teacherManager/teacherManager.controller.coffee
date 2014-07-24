'use strict'

angular.module('budweiserApp').controller 'TeacherManagerCtrl', ($scope, $http, Auth, User,$filter, $timeout,$upload) ->
  $scope.reloadUsers = ()->
    $http.get('/api/users').success (users) ->
      ###$scope.users = $filter('filter')(users, (user)->
          user._id isnt Auth.getCurrentUser()._id
        )###
      # more simplified
      $scope.users = $filter('filter')(users,{_id:"!" + Auth.getCurrentUser()._id})

  $scope.isExcelProcessing = false

  $scope.onFileSelect = (files)->
    if not files? or files.length < 1
      return
    #TODO: check file type by name or file type. pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
    if not /^.*\.(xls|XLS|xlsx|XLSX)$/.test files[0].name
      $scope.invalid = true
      return
    if files[0].size > 50 * 1024 * 1024
      $scope.invalid = true
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
        $http.post('/api/users/bulk',{key:data.key,orgId:Auth.getCurrentUser().orgId,type:'teacher'})
        .success (result)->
          console.log result
          $scope.reloadUsers()
        .error (error)->
          console.log error
        .finally ()->
          $scope.isExcelProcessing = false
      .error (response)->
        console.log response

  $scope.delete = (user) ->
    # Check if the user to delete is self.
    if user._id is Auth.getCurrentUser()._id
      return
    User.remove id: user._id
    angular.forEach $scope.users, (u, i) ->
      $scope.users.splice i, 1  if u is user

  $scope.reloadUsers()



