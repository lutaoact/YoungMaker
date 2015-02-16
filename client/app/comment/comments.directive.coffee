'use strict'

angular.module('mauiApp')

.directive 'comments', ->
  restrict: 'E'
  replace: true
  controller: 'CommentsCtrl'
  templateUrl: 'app/comment/comments.html'
  scope:
    me: '='
    belongTo: '='
    extra: '='
#    activeComment: '='
    type: '@'

.controller 'CommentsCtrl', (
  Auth
  $scope
  $state
  $modal
  $timeout
  $document
  Restangular
  messageModal
)->
  if !$scope.type
    throw 'should define type of comments directive'
  angular.extend $scope,
    newComment: {}
    commenting: false

    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 10

    createComment: ()->
      # validate
      @commenting = true
      @newComment.type = parseInt($scope.type)
      if !$scope.belongTo
        throw 'should define belongTo'
      $scope.newComment.belongTo = $scope.belongTo
      $scope.newComment.extra = $scope.extra
      Restangular.all('comments').post $scope.newComment
      .then (comment)->
        $scope.comments.splice 0, 0, comment
        $scope.initMyComment()
        $scope.commenting = false
        $scope.activeComment = comment._id
        $scope.$emit 'comments.number', $scope.comments.length

    initMyComment: ()->
      @newComment = {} if !@newComment
      @newComment.type = parseInt($scope.type)
      @newComment.content = ''

    toggleLike: (comment)->
      comment.one('like').post()
      .then (res)->
        comment.likeUsers = res.likeUsers

    deleteComment: (comment)->
      messageModal.open
        title: -> '删除评论？'
        message: -> "删除后将无法恢复！"
      .result.then ->
        comment.remove()
        .then ()->
          $scope.comments.splice $scope.comments.indexOf(comment), 1

    commentsFilter: (item)->
      switch $scope.viewState.filterMethod
        when 'all'
          return true
        when 'createdByMe'
          return item.postBy?._id is $scope.me._id
      return true

    scrollToEditor: ()->
      $timeout ->
        targetElement = angular.element('#new-comment')
        windowHeight = $(window).height()
        $document.scrollToElement(targetElement, windowHeight/2, 500)

    reload: ->
      Restangular.all('comments').getList
        belongTo:$scope.belongTo
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
      .then (comments)->
        $scope.comments = comments
        $scope.$emit 'comments.number', comments.length

  $scope.$watch 'belongTo', (value)->
    if value
      $scope.reload()

  $scope.$watch 'activeComment', (value)->
    if value
      $timeout ->
        targetElement = angular.element(document.getElementById value)
        targetElement.addClass('active')
        windowHeight = $(window).height();
        $document.scrollToElement(targetElement, windowHeight/2, 500)
        $timeout ->
          targetElement.removeClass('active')
        , 1000
      , 100
