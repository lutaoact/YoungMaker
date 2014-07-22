'use strict'

angular.module('budweiserApp').controller 'ClasseDetailCtrl', ($scope,$state,Restangular,Auth, $http,$upload) ->
  $scope.classe = null
  if $state.params.id and $state.params.id is 'new'
    $scope.classe = {}
  else if $state.params.id
    console.log $state.params.id
    Restangular.one('classes',$state.params.id).get()
    .then (classe)->
      $scope.classe = classe

  $scope.reloadStudents = ()->
    $scope.classe.all('students').getList()
    .then (students)->
      $scope.classe.students = students

  $scope.saveClasse = (classe,form)->
    if form.$valid
      classe.orgId = Auth.getCurrentUser().orgId
      if not classe._id
        #post
        Restangular.all('classes').post(classe)
        .then (data)->
          $scope.classe = data
          console.log $scope.classe
      else
        #put
        classe.put()

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
        $http.post('/api/users/bulk',{key:$scope.excelUrl,orgId:Auth.getCurrentUser().orgId,type:'student',classeId:$scope.classe._id})
        .success (result)->
          console.log result
          $scope.reloadStudents()
        .error (error)->
          console.log error
        .finally ()->
          $scope.isExcelProcessing = false

      .error (response)->
        console.log response


