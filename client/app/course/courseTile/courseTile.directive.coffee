'use strict'

angular.module('mauiApp').directive 'courseTile', ->
  templateUrl: 'app/course/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    me: '='
    course: '='
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth, messageModal, notify, $state)->
    angular.extend $scope,
      stopPropagation: ($event)->
        $event.stopPropagation()

      toggleVote: ()->
        $scope.course.one('like').post()
        .then (res)->
          $scope.course.likeUsers = res.likeUsers

      toggleCollect: ()->
        $scope.course.one('like').post()
        .then (res)->
          $scope.course.likeUsers = res.likeUsers

      removeCourse: (course)->
        messageModal.open
          title: -> '确定删除该课程？'
          message: -> '删除之后该课程内容及评论都将消失！'
        .result.then ->
          course.remove()
          .then ->
            notify
              message:'删除成功!'
              classes: 'alert-success'
            $state.reload()


