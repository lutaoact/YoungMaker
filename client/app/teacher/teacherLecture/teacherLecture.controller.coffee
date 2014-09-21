'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  notify
  $modal
  $upload
  configs
  $timeout
  fileUtils
  $location
  $rootScope
  Restangular
) ->

  $rootScope.additionalMenu = [
    {
      title: '主页'
      link: 'teacher.home'
      role: 'teacher'
    }
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "teacher.course({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "teacher.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []
    $rootScope.navInSub = false

  $rootScope.navInSub = true

  angular.extend $scope,

    mediaApi: undefined
    course: undefined
    lecture:
      slides:[]
      keyPoints:[]
      homeworks:[]
      quizzes:[]

    saveLecture: (lecture, form)->
      unless form?.$valid then return

      editingLecture = angular.extend angular.copy(lecture),
        keyPoints: _.map lecture.keyPoints, (keyPoint) ->
          kp: keyPoint.kp._id
          timestamp: keyPoint.timestamp
        homeworks: _.map lecture.homeworks, (q) -> q._id
        quizzes: _.map lecture.quizzes, (q) -> q._id

      if lecture._id?
        # update exists
        Restangular.copy(editingLecture).patch()
        .then (newLecture) ->
          lecture.__v = newLecture.__v
      else
        # create new
        Restangular.all('lectures').post(editingLecture, courseId:$state.params.courseId)
        .then ->
          $state.go('teacher.course.lectures', courseId: $state.params.courseId)

    removeSlide: (index) ->
      $scope.lecture.slides.splice(index, 1)
      $scope.lecture.patch?(slides: $scope.lecture.slides)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v

    removeMedia: ->
      $scope.lecture.media = null
      $scope.lecture.patch?(media: $scope.lecture.media)
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
        sortSlides = (a, b)->
          getNum = (str)->
            parseInt(str.split('-').reverse()[1])
          getNum(a) > getNum(b)
        console.log slides
        additional = slides.rawPics.sort(sortSlides).map (item, index)->
          thumb: "/api/assets/slides/#{slides.thumbnails.sort(sortSlides)[index]}"
          raw: "/api/assets/slides/#{item}"
        console.log additional
        $scope.lecture.slides = additional
        $scope.lecture.patch?(slides: $scope.lecture.slides)
        .then (newLecture) ->
          $scope.lecture.__v = newLecture.__v

    onImagesUploaded: (keys) ->
      $scope.lecture.slides =
        _.union($scope.lecture.slides, _.map(keys, (key) -> thumb:key))
      $scope.lecture.patch?(slides: $scope.lecture.slides)
      .then (newLecture) ->
        $scope.lecture.__v = newLecture.__v

    onMediaUploaded: (key) ->
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
    $scope.lecture = Restangular.one('lectures', $state.params.lectureId).get().$object

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
    Restangular.all('key_points').getList()
    .then (keyPoints) ->
      course.$keyPoints = keyPoints
    Restangular.all('questions').getList(categoryId:course.categoryId)
    .then (questions) ->
      course.$libraryQuestions = questions
