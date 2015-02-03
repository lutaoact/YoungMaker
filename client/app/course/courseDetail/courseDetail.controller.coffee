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

    submitComment: ()->
      if $scope.newComment?.content and $filter('htmlToPlaintext')($scope.newComment?.content).trim()
        Restangular.all('comments').post $scope.newComment
        .then (data)->
          $scope.newComment.content = ''
          console.log data
          $scope.comments.push data
      else
        alert('请输入内容')

  if $state.params.courseId
      Restangular.one('courses', $state.params.courseId).get()
      .then (course)->
        $scope.course = course

      Restangular.all('comments').getList({type:Const.CommentType.Course,belongTo:$state.params.courseId})
      .then (comments)->
        $scope.comments = comments



