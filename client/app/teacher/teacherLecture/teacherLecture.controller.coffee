'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  notify
  $upload
  $location
  qiniuUtils
  Restangular
) ->

  angular.extend $scope,

    slides: []
    lecture: undefined
    $state: $state
    uploading:
      ppt: false
      thumb: false
      media: false
      images: false
    uploadProgress:
      ppt: ''
      video: ''
      thumb: ''
      images: ''

    saveLecture: (lecture,form)->
      unless form.$valid then return
      (
        if lecture._id?
          # update exists
          lecture.patch(lecture)
        else
          # create new
          Restangular.all('lectures').post(lecture, courseId:$state.params.courseId)
      )
      .then ->
        notify
          message:'课时已保存'
          template:'components/alert/success.html'
        $state.go('teacher.course', id: $state.params.courseId)

    onThumbSelect: (files) ->
      $scope.uploading.thumb = true
      qiniuUtils.uploadFile
        files: files
        validation:
          max: 2*1024*1024
          accept: 'image'
        success: (key) ->
          $scope.uploading.thumb = false
          logoStyle ='?imageView2/2/w/210/h/140'
          $scope.lecture.thumbnail = key + logoStyle
          $scope.lecture?.patch?(thumbnail: $scope.lecture.thumbnail)
          .then (newLecture) ->
            $scope.lecture.__v = newLecture.__v
        fail: (error)->
          $scope.uploading.thumb = false
        progress: (speed,percentage, evt)->
          $scope.uploadProgress.thumb = parseInt(100.0 * evt.loaded / evt.total) + '%'

    onPPTSelect: (files)->
      $scope.uploading.ppt = true
      qiniuUtils.uploadFile
        files: files
        validation:
          max: 50 * 1024 * 1024
          accept: 'ppt'
        success: (key)->
          $scope.excelUrl = key
          $http.post('/api/users/sheet',{key:key,orgId: Auth.getCurrentUser().orgId})
          .success (result)->
            console.debug result
            $scope.uploading.ppt = false
        fail: (error)->
          $scope.uploading.ppt = false
        progress: (speed, percentage, evt)->
          $scope.uploadProgress.ppt = parseInt(100.0 * evt.loaded / evt.total) + '%'

    onImagesSelect: (files)->
      $scope.uploading.images = true
      qiniuUtils.bulkUpload
        files: files
        validation:
          max: 10*1024*1024
          accept: 'image'
        success: (keys)->
          $scope.uploading.images = false
          $scope.lecture.slides =
            _.union($scope.lecture.slides, _.map(keys, (key) -> thumb:key))
          console.debug $scope.lecture.slides
          $scope.lecture?.patch?(slides: $scope.lecture.slides)
          .then (newLecture) ->
            $scope.lecture.__v = newLecture.__v
        fail: (error)->
          $scope.uploading.images = false
        progress: (speed,percentage, evt)->
          $scope.uploadProgress.images = parseInt(100.0 * evt.loaded / evt.total) + '%'

    onMediaSelect: (files)->
      $scope.uploading.media = true
      qiniuUtils.uploadFile
        files: files
        validation:
          max: 100*1024*1024
          accept: 'video'
        success: (key)->
          $scope.uploading.media = false
          $scope.lecture.media = key
          $scope.lecture?.patch?(media: $scope.lecture.media)
          .then (newLecture) ->
            $scope.lecture.__v = newLecture.__v
        fail: (error)->
          $scope.uploading.media = false
        progress: (speed,percentage, evt)->
          $scope.uploadProgress.media = parseInt(100.0 * evt.loaded / evt.total) + '%'

  if $state.params.id is 'new'
    $scope.lecture = {}
  else
    $scope.lecture = Restangular.one('lectures', $state.params.id).get().$object

