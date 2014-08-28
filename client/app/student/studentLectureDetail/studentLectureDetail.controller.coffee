'use strict'

angular.module('budweiserApp').controller 'StudentLectureDetailCtrl'
, (
  $scope
  $state
  Restangular
  Auth,
  $http
  $upload
  $location
  notify
  qiniuUtils
  $tools
) ->

  loadLecture = ()->
    if $state.params.lectureId and $state.params.lectureId is 'new'
      $scope.lecture = {courseId:$state.params.courseId}
    else if $state.params.lectureId
      Restangular.one('lectures',$state.params.lectureId).get()
      .then (lecture)->
        $scope.lecture = lecture

  loadCourse = ()->
    Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course

  angular.extend $scope,
    lecture: null

    course: null

    $stateParams: $state.params

    saveLecture: (lecture,form)->
      if form.$valid
        if not lecture._id
          #post
          $scope.all('lectures').post lecture,
            courseId: $state.params.courseId
          .then (data)->
            notify
              message:'课时已保存'
              template:'components/alert/success.html'
            $state.go 'teacher.lectureDetail',
              courseId: $state.params.courseId
              lectureId: data._id
        else
          #put
          lecture.put()

    seek: (timestamp)->
      $scope.mediaPlayerAPI?.seekTime timestamp if timestamp?

    patchLecture: ()->
      if not lecture._id
        #post
        Restangular.all('lectures').post(lecture)
        .then (data)->
          notify({message:'课时已保存',template:'components/alert/success.html'})
          $state.go('editLectureDetail',{lectureId:data._id})
      else
        #put
        patch = {}
        patch[field] = lecture[field]
        lecture.patch(patch)
        .then (data)->
          angular.extend $scope.lecture, data
          notify({message:'课时已保存',template:'components/alert/success.html'})

    mediaPlayerAPI: undefined

    onPlayerReady: (playerAPI) ->
      $scope.mediaPlayerAPI = playerAPI
      seekHashTimestamp()

    onUpdateTime: (time) ->
      # unless $scope.lecture? then return
      # activedSlide = _.findLast($scope.lecture.slides, (slide) ->
      #   slide.timestamp <= time
      # )
      # if activedSlide?
      #   activedSlide.$active = true
      # # active first one
      # else
      #   _.first($scope.lecture.slides)?.$active = true

  seekHashTimestamp = ->
    total = $tools.timeStrings2Seconds $location.hash()
    $scope.mediaPlayerAPI?.seekTime total if total?

  loadCourse()

  loadLecture()
