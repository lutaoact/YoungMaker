'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  $modal
  notify
  Navbar
  $filter
  Courses
  KeyPoints
  Restangular
  $sce
) ->

  course =  _.find Courses, _id :$state.params.courseId

  Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,

    course: course
    keyPoints: KeyPoints
    mediaApi: null
    saving: false
    deleting: false
    videoActive: true
    pptViewer:
      $listToggled: true
    lecture: null
    editingInfo: null
    editingProgress: # 0=new, 1/2=half, 1=done
      info: 1
      media: 1
      question: 1
      done: 3 # 多少个已经完成的

    switchEdit: ->
      $scope.editingInfo =
        if !$scope.editingInfo?
          _.pick $scope.lecture, [
            'name'
            'info'
            'thumbnail'
          ]
        else
          null

    deleteLecture: ->
      lecture = $scope.lecture
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时'
          message: -> """确认要删除《#{$scope.course.name}》中的"#{lecture.name}"？"""
      .result.then ->
        $scope.deleting = true
        $scope.lecture.remove(courseId:$scope.course._id)
        .then ->
          $scope.deleting = false
          $scope.editingInfo = null
          $scope.lecture = null
          $state.go('teacher.course', courseId:$scope.course._id)

    saveLecture: (form) ->
      unless form?.$valid then return
      $scope.saving = true
      lecture = $scope.lecture
      editingInfo = $scope.editingInfo
      lecture.patch(editingInfo)
      .then (newLecture) ->
        angular.extend lecture, editingInfo
        $scope.saving = false
        $scope.editingInfo = null
        $scope.updateEditingProgress(newLecture)
        notify '课时信息已保存'

    removeSlide: (index) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除PPT页面'
          message: -> """确认要删除"#{$scope.lecture.name}"中PPT的第#{index+1}页？"""
      .result.then ->
        $scope.lecture.slides.splice(index, 1)
        $scope.lecture.patch?(slides: $scope.lecture.slides)
        .then $scope.updateEditingProgress

    sortSlides: ->
      $scope.lecture.patch?(slides:$scope.lecture.slides)
      .then $scope.updateEditingProgress

    removeMedia: ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时视频'
          message: -> """确认要删除"#{$scope.lecture.name}"的视频？"""
      .result.then ->
        $scope.lecture.media = null
        $scope.lecture.$mediaSource = [
        ]
        $scope.lecture.patch?(media: $scope.lecture.media)
        .then $scope.updateEditingProgress

    removePPT: ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时PPT'
          message: -> """确认要删除"#{$scope.lecture.name}"的PPT？"""
      .result.then ->
        $scope.lecture.slides = []
        $scope.lecture.patch?(slides: $scope.lecture.slides)
        .then $scope.updateEditingProgress

    onError: (error) -> notify "上传失败：" + error
    onPPTUploadStart: ->
      $scope.pptUploadState = null
      $scope.pptUploadProgress = 0
      $scope.pptUploadInfo = ''
    onPPTUploading: (speed, progress, event) ->
      $scope.pptUploadState = 'uploading'
      $scope.pptUploadProgress = progress
      $scope.pptUploadInfo = "上传率" + $filter('bytes')(event.loaded) + "/" + $filter('bytes')(event.total)
    onPPTConverting: ->
      $scope.pptUploadState = 'converting'
      $scope.pptUploadProgress = 100
      $scope.pptUploadInfo = ''
    onPPTUploaded: (data) ->
      $scope.pptUploadState = null
      $scope.pptUploadProgress = null
      $scope.pptUploadInfo = ''
      $scope.lecture.slides = data
      $scope.lecture.patch?(slides: $scope.lecture.slides)
      .then $scope.updateEditingProgress

    onMediaUploadStart: ->
      console.debug 'media upload start'
    onMediaUploading: (speed, progress, event) ->
      console.debug 'media uploading', speed, progress
    onMediaConverting: ->
      console.debug 'media converting'
    onMediaUploaded: (data) ->
      $scope.lecture.media = data
      $scope.lecture.$mediaSource = [
        src: $sce.trustAsResourceUrl($scope.lecture.media)
        type: 'video/mp4'
      ]
      $scope.lecture.patch?(media: $scope.lecture.media)
      .then $scope.updateEditingProgress

    onPlayerReady: (api) ->
      $scope.mediaApi = api

    updateEditingProgress: (newLecture = null) ->
      lecture = $scope.lecture
      lecture.__v = newLecture.__v if newLecture?
      progress = $scope.editingProgress
      progress.info = 0
      progress.media = 0
      progress.question = 0
      progress.info += 1/2 if lecture.name?.length > 0
      progress.info += 1/2 if lecture.info?.length > 0
      progress.media += 1/2 if lecture.media?.length > 0
      progress.media += 1/2 if lecture.slides?.length > 0
      progress.question += 1/2 if lecture.quizzes?.length > 0
      progress.question += 1/2 if lecture.homeworks?.length > 0
      progress.done = progress.info + progress.media + progress.question

    genTooltip: (progress, label) ->
      label +
        if progress == 0 then '未添加'
        else if progress == 1/2 then '不完整'
        else '已添加'

  Restangular.one('lectures', $state.params.lectureId).get()
  .then (lecture) ->
    lecture.$mediaSource = [
      src: $sce.trustAsResourceUrl(lecture.media)
      type: 'video/mp4'
    ]
    $scope.lecture = lecture
    $scope.videoActive = lecture.media? || lecture.slides.length == 0
    $scope.switchEdit() if lecture.__v == 0
    $scope.updateEditingProgress()

  # 删除未保存过的课时
  $scope.$on '$destroy', ->
    $scope.lecture.remove(courseId:$scope.course._id) if $scope.lecture?.__v == 0
