angular.module('mauiApp')

.controller 'CourseDetailCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
  $filter
  $document
  $window
  mediaHelper
  messageModal
  $timeout
  $location
) ->

  angular.extend $scope,
    newComment: {
      type    : Const.CommentType.Course
      belongTo: $state.params.courseId
    }
    comments: null

    viewState:
      stepIndex: 0
      stepThumbs: 8
      stepDots: 3

    removeCourse: (course)->
      messageModal.open
        title: -> '确定删除该课程？'
        message: -> '删除之后该课程内容及评论都将消失！'
      .result.then ->
        # todo should go back
        course.remove()
        .then ->
          notify
            message:'删除成功!'
            classes: 'alert-success'
          $state.go 'courseList'

    showWechatShareBtn: ()->
      window.WeixinJSBridge?

    wechatShare: ->
      wxShare.shareTimeline()

  if $state.params.courseId
      Restangular.one('courses', $state.params.courseId).get(viewer: true)
      .then (course)->
        if !course
          $state.go '404', url : $state.href($state.current, $state.params),
            location:'replace'
          return
        $scope.course = course
        wxShare.init
          shareTitle: course.title
          descContent: course.info
          lineLink: $location.$$absUrl

      Restangular.all('comments').getList({type:Const.CommentType.Course,belongTo:$state.params.courseId})
      .then (comments)->
        $scope.comments = comments

  $scope.$on 'duScrollspy:becameActive', ($event, $element)->
    $timeout ->
      $scope.viewState.selectedStep = $element.scope().step
      $scope.viewState.stepIndex = $scope.course.steps.indexOf($scope.viewState.selectedStep) + 1

  resizeHandle = ->
    if mediaHelper.isLg()
      $scope.viewState.stepThumbs = 8
    else if mediaHelper.isMd()
      $scope.viewState.stepThumbs = 6
    else if mediaHelper.isSm()
      $scope.viewState.stepThumbs = 5
    else
      $scope.viewState.stepThumbs = 3

  resizeHandle()

  $(window).bind 'resize', resizeHandle

  $scope.$on '$destroy', ->
    $(window).unbind 'resize', resizeHandle





