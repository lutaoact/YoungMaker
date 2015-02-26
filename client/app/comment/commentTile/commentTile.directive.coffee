'use strict'

angular.module('mauiApp').directive 'commentTile', ->
  restrict: 'EA'
  replace: true
  scope:
    me: '='
    comment: '='
  templateUrl: (element, attrs) ->
    switch attrs.type
      when 'simple'
        'app/comment/commentTile/commentTileSimple.html'
      else
        'app/comment/commentTile/commentTile.html'

  controller: ($scope, Restangular, Auth, messageModal, notify, $state)->
    angular.extend $scope,
      stopPropagation: ($event)->
        $event.stopPropagation()

      toggleVote: ()->
        $scope.comment.one('like').post()
        .then (res)->
          $scope.comment.likeUsers = res.likeUsers

      toggleCollect: ()->
        $scope.comment.one('like').post()
        .then (res)->
          $scope.comment.likeUsers = res.likeUsers

      removeComment: (comment)->
        messageModal.open
          title: -> '确定删除该课程？'
          message: -> '删除之后该课程内容及评论都将消失！'
        .result.then ->
          comment.remove()
          .then ->
            notify
              message:'删除成功!'
              classes: 'alert-success'
            $state.reload()

    $scope.$watch 'comment', (value)->
      if value and $scope.comment.belongTo
        Restangular.one(Const.CommentRef[$scope.comment.type]+'s', $scope.comment.belongTo).get()
        .then (data)->
          $scope.comment.$belongTo = data


