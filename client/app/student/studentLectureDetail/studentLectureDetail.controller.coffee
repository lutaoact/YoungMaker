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
  fileUtils
  $tools
  $rootScope
  CurrentUser
  $timeout
) ->

  $rootScope.additionalMenu = [
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "student.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '讨论<i class="fa fa-comments-o"></i>'
      link: "forum.course({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "student.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []

  loadLecture = ()->
    if $state.params.lectureId and $state.params.lectureId is 'new'
      $scope.lecture = {courseId:$state.params.courseId}
    else if $state.params.lectureId
      Restangular.one('lectures',$state.params.lectureId).get()
      .then (lecture)->
        $scope.lecture = lecture
        # If student stay over 5 seconds. Send view lecture event.
        $timeout ->
          console.log 'view'
          Restangular.all('activities').post
            eventType: Const.Student.ViewLecture
            data:
              lectureId: $scope.lecture._id
              courseId: $scope.course._id
        , 5000
        $scope.lecture

  loadCourse = ()->
    Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course

  angular.extend $scope,
    lecture: null

    course: null

    me: CurrentUser

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
      if $scope.mediaPlayerAPI
        $scope.mediaPlayerAPI?.seekTime timestamp if timestamp?

    currentTime: 0

    isKeypointActive: (keypoint)->
      $scope.currentTime >= keypoint.timestamp and ($scope.currentTime < findNextStamp(keypoint)?.timestamp or not findNextStamp(keypoint))

    onUpdateTime: (now,total)->
      $scope.currentTime = now

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

  seekHashTimestamp = ->
    total = $tools.timeStrings2Seconds $location.hash()
    $scope.mediaPlayerAPI?.seekTime total if total?

  findNextStamp = (keypoint)->
    ($scope.lecture.keyPoints.filter (item)->
      item.timestamp > keypoint.timestamp
    .sort (a,b)->
      a.timestamp >= b.timestamp
    )?[0]

  $scope.$watch 'viewState',(newVal)->
    # important: free the reference of videogular
    if not newVal?.isVideo
      $scope.mediaPlayerAPI = undefined
  ,true

  loadCourse()

  loadLecture()
