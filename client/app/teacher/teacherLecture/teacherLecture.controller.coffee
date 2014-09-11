'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  notify
  $modal
  $upload
  $location
  qiniuUtils
  Restangular
  $timeout
) ->

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
          $state.go('teacher.course', id: $state.params.courseId)

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
      $http.post('/api/slides/' + encodeURIComponent(key), null, timeout:10*60*1000)
      .success (imageKeys)->
        if angular.isArray imageKeys
          $scope.lecture.slides =
            _.union($scope.lecture.slides, _.map(imageKeys, (key) -> thumb:key))
          $scope.lecture.patch?(slides: $scope.lecture.slides)
          .then (newLecture) ->
            $scope.lecture.__v = newLecture.__v
        else
          notify(message:'转换失败，请联系info@cloud3edu.com', template:'components/alert/failure.html')

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
