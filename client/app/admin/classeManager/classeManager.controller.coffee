'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $scope,
  Restangular) ->

  angular.extend $scope,
    classesQ: Restangular.all('classes').getList()

.controller 'ClasseManagerDetailCtrl', (
  Auth,
  $scope,
  $state,
  Restangular) ->

  angular.extend $scope,

    selectedClasse: undefined

    saveClasse: (classe, form) ->
      if !form.$valid then return
      classe.orgId = Auth.getCurrentUser().orgId
      if not classe._id
        #create new classe
        Restangular.all('classes').post(classe).then (newClasse)->
          #TODO refactor
          $scope.classesQ.$object.push(newClasse)
          $state.go('admin.classeManager.detail', classeId:newClasse._id)
      else
        #update classe
        classe.put()

    deleteClasse: (classe) ->
      classe.remove().then ->
        classes = $scope.classesQ.$object
        index = _.indexOf(classes, classe)
        classes.splice(index, 1)
        $state.go('admin.classeManager.detail', classeId:classes[0]._id) if classes[0]?


  $scope.classesQ.then ->
    $scope.selectedClasse = _.find($scope.classesQ.$object, _id:$state.params.classeId) ? {}
    if !$scope.selectedClasse._id || $scope.selectedClasse.students then return
    $scope.selectedClasse.all('students').getList().then (students) ->
      $scope.selectedClasse.students = students


  #TODO refactor
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

