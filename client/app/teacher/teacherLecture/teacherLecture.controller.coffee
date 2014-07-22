'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', ($scope,$state,Restangular,Auth, $http,$upload,$location) ->
  $scope.lecture = null
  console.log $state.params
  if $state.params.id and $state.params.id is 'new'
    $scope.lecture = {courseId:$state.params.courseId}
  else if $state.params.id
    Restangular.one('lectures',$state.params.id).get()
    .then (lecture)->
      $scope.lecture = lecture

  $scope.isPptProcessing = false

  $scope.onFileSelect = (files)->
    if not files? or files.length < 1
      return
    #TODO: check file type by name or file type. pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
    if not /^.*\.(ppt|PPT|pptx|PPTX)$/.test files[0].name
      $scope.invalid = true
      return
    if files[0].size > 50 * 1024 * 1024
      $scope.invalid = true
      return

    $scope.isPptProcessing = true
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
        $http.post('/api/users/sheet',{key:data.key,orgId:Auth.getCurrentUser().orgId})
        .success (result)->
          console.log result
        .error (error)->
          console.log error
        .finally ()->
          $scope.isPptProcessing = false
      .error (response)->
        console.log response

  $scope.saveLecture = (lecture,form)->
    if form.$valid
      if not lecture._id
        #post
        Restangular.all('lectures').post(lecture)
        .then (data)->
          console.log lecture
      else
        #put
        lecture.put()

