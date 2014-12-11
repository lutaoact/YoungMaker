'use strict'

angular.module('mauiApp').directive 'comments', ->
  templateUrl: 'app/comment/comments.html'
  restrict: 'EA'
  replace: true
  scope:
    belongTo: '@'
    type: '@'
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, $filter, Auth)->
    angular.extend $scope,
      getMe: Auth.getCurrentUser
      newComment: {
        type    : Const.CommentType.Course
        belongTo: $scope.belongTo
      }
      comments: null
      const: Const

      submitComment: ()->
        if $scope.newComment?.content and ($scope.newComment?.content.indexOf('img')>0 or $filter('htmlToPlaintext')($scope.newComment?.content).trim())
          Restangular.all('comments').post $scope.newComment
          .then (data)->
            $scope.newComment.content = ''
            console.log data
            $scope.comments.push data
        else
          alert('请输入内容')

    $scope.$watch 'belongTo', (value)->
      if value
        $scope.newComment.belongTo = $scope.belongTo
        Restangular.all('comments').getList({type:$scope.type,belongTo:$scope.belongTo})
        .then (comments)->
          $scope.comments = comments



