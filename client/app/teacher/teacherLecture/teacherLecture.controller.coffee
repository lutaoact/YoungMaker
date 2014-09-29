'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  $modal
  configs
  Courses
  KeyPoints
  $urlRouter
  $rootScope
  Restangular
) ->

  course =  _.find Courses, _id :$state.params.courseId

  angular.extend $scope,

    course: course
    keyPoints: KeyPoints
    mediaApi: null
    saving: false
    deleting: false
    videoActive: true
    lecture: null
    editingInfo: null

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
          $state.go('teacher.course', courseId:$scope.course._id)

    saveLecture: (form) ->
      unless form?.$valid then return

      $scope.saving = true

      lecture = $scope.lecture
      editingInfo = $scope.editingInfo

      lecture.patch(editingInfo)
      .then (newLecture) ->
        $scope.saving = false
        lecture.__v = newLecture.__v
        angular.extend lecture, editingInfo
        $scope.editingInfo = null

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
        .then (newLecture) ->
          $scope.lecture.__v = newLecture.__v

    removeMedia: ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时视频'
          message: -> """确认要删除"#{$scope.lecture.name}"的视频？"""
      .result.then ->
        $scope.lecture.media = null
        $scope.lecture.patch?(media: $scope.lecture.media)
        .then (newLecture) ->
          $scope.lecture.__v = newLecture.__v

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
        .then (newLecture) ->
          $scope.lecture.__v = newLecture.__v

    onThumbUploaded: (key) ->
      $scope.editingInfo.thumbnail = key

    onPPTUploaded: (key) ->
      $http.post configs.fpUrl + 'api/convert?key=' + encodeURIComponent(key)
      .success (slides)->
        fileShortKey = (slides.thumbnails[0].split('-').slice 0, -2).join('-')
        console.log fileShortKey
        additional = [1..slides.total/2].map (item)->
          thumb: '/api/assets/slides/' + fileShortKey + '-' + item + '-sm.jpg'
          raw:  '/api/assets/slides/' + fileShortKey + '-' + item + '-lg.jpg'
        console.log additional
        $scope.lecture.slides = additional
        $scope.lecture.patch?(slides: $scope.lecture.slides)
        .then (newLecture) ->
          $scope.lecture.__v = newLecture.__v

    onMediaUploaded: (key, data) ->
      $scope.lecture.media = key
      $scope.lecture.patch?(media: $scope.lecture.media)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v

    onPlayerReady: (api) ->
      $scope.mediaApi = api

  Restangular.one('lectures', $state.params.lectureId).get()
  .then (lecture) ->
    $scope.lecture = lecture
    $scope.videoActive = lecture.media? || lecture.slides.length == 0
    $scope.switchEdit() if lecture.__v == 0

  $scope.$on 'ngrr-reordered', ->
    $scope.lecture.patch?(slides:$scope.lecture.slides)
    .then (newLecture) ->
      $scope.lecture.__v = newLecture.__v

  # save or discard confirm
  askForSaveLecture = ->
    $modal.open
      templateUrl: 'components/modal/messageModal.html'
      controller: 'MessageModalCtrl'
      resolve:
        title: -> '保存课时'
        message: -> """课时"#{$scope.lecture.name}"的基本信息还没有保存，请先保存。"""

  discardNewLecture = (toState, toParams) ->
    $modal.open
      templateUrl: 'components/modal/messageModal.html'
      controller: 'MessageModalCtrl'
      resolve:
        title: -> '舍弃新课时'
        message: -> """课时"#{$scope.lecture.name}"还没有被保存过，舍弃并离开？"""
    .result.then ->
      $scope.deleting = true
      $scope.lecture.remove(courseId:$scope.course._id)
      .then ->
        $scope.deleting = false
        $scope.editingInfo = null
        $state.go(toState, toParams)

  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    isEditing = $scope.editingInfo?
    isGoingOut = !$state.includes(toState, toParams) &&  toState.name != 'teacher.lecture.questionLibrary'
    if isEditing && isGoingOut
      event.preventDefault()
      if $scope.lecture.__v == 0
        discardNewLecture(toState, toParams)
      else
        askForSaveLecture()

