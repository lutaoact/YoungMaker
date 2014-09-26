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
  Restangular
) ->

  course =  _.find Courses, _id :$state.params.courseId

  angular.extend $scope,

    course: course
    keyPoints: KeyPoints
    mediaApi: null
    editing: false
    saving: false
    tabActive:
      media:true
      ppt:false
    lecture:
      name: "新建课时 #{course.lectureAssembly.length + 1}"
      slides:[]
      keyPoints: []
      homeworks:[]
      quizzes:[]

    switchEdit: ->
      $scope.editing = !$scope.editing

    saveLecture: (lecture, form) ->
      unless form?.$valid then return

      $scope.saving = true

      # change list[Object] to list[ID]
      editingLecture = angular.extend angular.copy(lecture),
        keyPoints: _.map lecture.keyPoints, (keyPoint) ->
          kp: keyPoint.kp._id
          timestamp: keyPoint.timestamp
        homeworks: _.pluck lecture.homeworks, '_id'
        quizzes: _.pluck lecture.quizzes, '_id'

      if lecture._id?
        # update exists
        Restangular.copy(editingLecture).patch()
        .then (newLecture) ->
          $scope.editing = $scope.saving = false
          lecture.__v = newLecture.__v
      else
        # create new
        Restangular.all('lectures').post(editingLecture, courseId:$state.params.courseId)
        .then ->
          $scope.editing = $scope.saving = false
          $state.go('teacher.course', courseId: $state.params.courseId)

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
      $scope.lecture.thumbnail = key
      $scope.lecture.patch?(thumbnail: $scope.lecture.thumbnail)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v

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

  $scope.$on 'ngrr-reordered', ->
    $scope.lecture.patch?(slides:$scope.lecture.slides)
    .then (newLecture) ->
      $scope.lecture.__v = newLecture.__v

  if $state.params.lectureId isnt 'new'
    Restangular.one('lectures', $state.params.lectureId).get()
    .then (lecture) ->
      $scope.lecture = lecture
      $scope.tabActive.ppt = lecture.slides?.length > 0 && !lecture.media?
  else
    $scope.editing = true
