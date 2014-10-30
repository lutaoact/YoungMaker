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
    Restangular.one('lectures', $state.params.lectureId).get()
    .then (lecture)->
      $scope.lecture = lecture
      $scope.viewState.isVideo = lecture.media or !lecture.files
      if lecture.media
        $scope.viewState.videos = [
          src: $sce.trustAsResourceUrl(lecture.media)
          type: 'video/mp4'
        ]
      $scope.switchFile(lecture.files[0])
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
    selectedFile: null
    me: CurrentUser

    viewState:
      isVideo: true
      videos: null
      # Should not set to ```false```, once it is set to ```true```,
      # because ```ng-if="false"``` will destroy the controller and view
      discussPanelnitialized: false
      notesPanelnitialized: false

    $stateParams: $state.params

    switchFile: (file) ->
      $scope.selectedFile = file

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

    toggleNotesPanel: ()->
      if !@viewState.notesPanelnitialized
        @viewState.notesPanelnitialized = true
        $scope.noteLoading = true
        $timeout ->
          $scope.noteLoading = false
          $scope.viewState.showNotes = true
        , 1000
      else
        @viewState.showNotes = !@viewState.showNotes

    disableDownload: ()->
      console.log 'you are not allowed to download this resource'

  $scope.$watch 'viewState', (value)->
    if $scope.viewState.showDiscussion or $scope.viewState.showNotes
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
    #$document.scrollToElement(ele, 60, 2000)
    $document.scrollTo(0, 80, 2000)

