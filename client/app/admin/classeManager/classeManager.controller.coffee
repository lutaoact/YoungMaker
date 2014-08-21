'use strict'

angular.module('budweiserApp').controller 'ClasseManagerCtrl', (
  Auth,
  $scope,
  $state,
  $location,
  $rootScope,
  Restangular) ->

  angular.extend $scope,
    selectedClasse: undefined
    classes: []

    newClasse: ->
      $location.search(classe: 'new')

    selectClasse: (classe) ->
      $location.search(classe: classe._id)

    saveClasse: (classe, form) ->
      if !form.$valid then return
      classe.orgId = Auth.getCurrentUser().orgId
      if not classe._id
        #create new classe
        Restangular.all('classes').post(classe).then (newClasse)->
          $scope.selectClasse newClasse
      else
        #update classe
        classe.put()

  loadClasseStudents = ->
    if $scope.selectedClasse.students then return
    $scope.selectedClasse.all('students').getList().then (students) ->
      $scope.selectedClasse.students = students

  applySelectedClasse = ->
    classe = $location.search()?.classe
    if classe == 'new'
      $scope.selectedClasse = {}
    else
      $scope.selectedClasse = _.find($scope.classes, _id:classe)
      if $scope.selectedClasse?
        loadClasseStudents()
      else if $scope.classes[0]?
        $scope.selectClasse($scope.classes[0])
      else
        console.log 'Please create new class.'

  $rootScope.$on '$locationChangeSuccess', applySelectedClasse

  Restangular.all('classes').getList().then (classes)->
    $scope.classes = classes
    applySelectedClasse()


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
