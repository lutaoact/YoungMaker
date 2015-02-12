angular.module('mauiApp')

.controller 'CourseDetailCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
  $filter
) ->

  angular.extend $scope,
    newComment: {
      type    : Const.CommentType.Course
      belongTo: $state.params.courseId
    }
    comments: null

    viewState:
      stepIndex: 0
      stepThumbs: 3
      stepDots: 3

    submitComment: ()->
      if $scope.newComment?.content and $filter('htmlToPlaintext')($scope.newComment?.content).trim()
        Restangular.all('comments').post $scope.newComment
        .then (data)->
          $scope.newComment.content = ''
          $scope.comments.push data
      else
        alert('请输入内容')

    removeCourse: (course)->
      course.remove()
      .then ->
        notify
          message:'删除成功!'
          classes: 'alert-success'
        $state.go 'courseList'

  if $state.params.courseId
      Restangular.one('courses', $state.params.courseId).get()
      .then (course)->
        $scope.course = course

      Restangular.all('comments').getList({type:Const.CommentType.Course,belongTo:$state.params.courseId})
      .then (comments)->
        $scope.comments = comments

  $scope.$on 'duScrollspy:becameActive', ($event, $element)->
    $scope.viewState.selectedStep = $element.scope().step
    $scope.viewState.stepIndex = $scope.course.steps.indexOf($scope.viewState.selectedStep) + 1




