'use strict'

angular.module('budweiserApp').directive 'ngRightClick', ($parse) ->
  link: (scope, element, attrs) ->
    fn = $parse(attrs.ngRightClick)
    element.bind 'contextmenu', (event) ->
      scope.$apply () ->
        event.preventDefault()
        fn scope, {$event:event}

.controller 'StudentLectureDetailCtrl'
, (
  $scope
  $state
  notify
  Navbar
  Courses
  $timeout
  $document
  CurrentUser
  Restangular
  $localStorage
  $sce
) ->

  course = _.find Courses, _id:$state.params.courseId

  Navbar.setTitle course.name, "student.courseDetail({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  # TODO: remove this line. Fix in videogular
  $scope.$on '$destroy', ()->
    # clear video
    angular.element('video').attr 'src', ''

    #clear silder
    angular.element('body').removeClass 'sider-open'

  loadLecture = ()->
    if $state.params.lectureId
      Restangular.one('lectures',$state.params.lectureId).get()
      .then (lecture)->
        $scope.lecture = lecture
        $scope.viewState.isVideo = lecture.media or !lecture.slides
        if lecture.media
          $scope.viewState.videos = [
            src: $sce.trustAsResourceUrl(lecture.media)
            type: 'video/mp4'
          ]
        # If student stay over 5 seconds. Send view lecture event.
        handleViewEvent = $timeout ->
          Restangular.all('activities').post
            eventType: Const.Student.ViewLecture
            data:
              lectureId: $scope.lecture._id
              courseId: $scope.course._id
        , 5000
        $scope.$on '$destroy', ()->
          $timeout.cancel handleViewEvent
        $scope.lecture

  angular.extend $scope,
    course: course
    lecture: null
    me: CurrentUser

    viewState:
      isVideo: true
      videos: null
      # Should not set to ```false```, once it is set to ```true```,
      # because ```ng-if="false"``` will destroy the controller and view
      discussPanelnitialized: false

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
      $scope.viewState.isVideo = true
      if $scope.mediaPlayerAPI
        $scope.mediaPlayerAPI?.seekTime timestamp if timestamp?

    currentTime: 0

    isKeypointActive: (keypoint)->
      $scope.currentTime >= keypoint.timestamp and ($scope.currentTime < findNextStamp(keypoint)?.timestamp or not findNextStamp(keypoint))

    onUpdateTime: (now,total)->
      $scope.currentTime = now
      # store current time in local storage
      # localStorage.:userId.lectures.:lectureId.videoPlayTime
      $localStorage[$scope.me._id] ?= {}
      $localStorage[$scope.me._id]['lectures'] ?= {}
      lectureState = $localStorage[$scope.me._id]['lectures'][$state.params.lectureId] ?= {}
      lectureState.videoPlayTime = $scope.currentTime

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
      if playerAPI.isReady
        $scope.mediaPlayerAPI = playerAPI
        timestamp = $localStorage[$scope.me._id]?['lectures']?[$state.params.lectureId]?.videoPlayTime
        if timestamp
          playerAPI.seekTime timestamp

    toggleDiscussionPanel: ()->
      @viewState.discussPanelnitialized = true
      @viewState.showDiscussion = !@viewState.showDiscussion

    disableDownload: ()->
      console.log 'you are not allowed to download this resource'

  $scope.$watch 'viewState', (value)->
    if $scope.viewState.showDiscussion
      angular.element('body').addClass 'sider-open'
    else
      angular.element('body').removeClass 'sider-open'
  , true

  findNextStamp = (keypoint)->
    ($scope.lecture.keyPoints.filter (item)->
      item.timestamp > keypoint.timestamp
    .sort (a,b)->
      a.timestamp >= b.timestamp
    )?[0]

  loadLecture()

  # scroll to content-view after document ready
  $document.ready ->
    ele = angular.element('#content-view')
    #$document.scrollToElement(ele, 60, 2000)
    $document.scrollTo(0, 150, 2000)

