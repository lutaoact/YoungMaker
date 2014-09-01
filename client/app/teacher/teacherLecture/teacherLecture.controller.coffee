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

    mediaAPI: undefined
    course: undefined
    lecture: undefined
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

    saveLecture: (lecture, form)->
      unless form.$valid then return
      (
        if lecture._id?
          # update exists
          Restangular.copy(lecture).patch()
        else
          # create new
          Restangular.all('lectures').post(lecture, courseId:$state.params.courseId)
      )
      .then ->
        notify
          message:'课时已保存'
          template:'components/alert/success.html'
        $state.go('teacher.course', id: $state.params.courseId)

    removeSlide: (index) ->
      $scope.lecture.slides.splice(index, 1)
      $scope.lecture?.patch?(slides: $scope.lecture.slides)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v

    removeMedia: ->
      $scope.lecture.media = null
      $scope.lecture?.patch?(media: $scope.lecture.media)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v


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
          $http.post('/api/slides/' + encodeURIComponent(key), null, timeout:10*60*1000)
          .success (imageKeys)->
            $scope.uploading.ppt = false
            if angular.isArray imageKeys
              $scope.lecture.slides =
                _.union($scope.lecture.slides, _.map(imageKeys, (key) -> thumb:key))
              $scope.lecture?.patch?(slides: $scope.lecture.slides)
              .then (newLecture) ->
                $scope.lecture.__v = newLecture.__v
            else
              notify(message:'转换失败，请联系info@cloud3edu.com', template:'components/alert/failure.html')
        fail: (error)->
          $scope.uploading.ppt = false
        progress: (speed, percentage, evt)->
          $scope.uploadProgress.ppt = parseInt(100.0 * evt.loaded / evt.total) + '%'

    onImagesSelect: (files) ->
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
        fail: (error) ->
          $scope.uploading.media = false
        progress: (speed,percentage, evt)->
          $scope.uploadProgress.media = parseInt(100.0 * evt.loaded / evt.total) + '%'

    onPlayerReady: (api) ->
      $scope.mediaAPI = api

    # TODO refactor keypoint ctrl / service
    keypointFormatter: ($model) -> $model?.name

    addKeypoint: (keypoint) ->
      $scope.lecture.keypoints.push
        kp : keypoint
        timestamp: 0
      $scope.saveKeypoints()

    removeKeypoint: (index) ->
      $scope.lecture.keypoints.splice(index, 1)
      $scope.saveKeypoints()

    updateKeypoint: (keypoint) ->
      currentTime = $scope.mediaAPI.videoElement[0].currentTime
      keypoint.timestamp = Math.ceil(currentTime)
      $scope.saveKeypoints()

    saveKeypoints: ->
      newKeypoints = _.map $scope.lecture.keypoints, (keypoint) ->
        kp: keypoint.kp._id
        timestamp: keypoint.timestamp
      $scope.lecture.patch(keypoints:newKeypoints)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v

  $scope.$on 'ngrr-reordered', ->
    $scope.lecture.patch(slides:$scope.lecture.slides)
    .then (newLecture) ->
      $scope.lecture.__v = newLecture.__v

  if $state.params.id is 'new'
    $scope.lecture = {}
  else
    $scope.lecture = Restangular.one('lectures', $state.params.id).get().$object

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
    Restangular.all('key_points').getList(categoryId:course.categoryId)
    .then (keypoints) ->
      course.$keypoints = keypoints

