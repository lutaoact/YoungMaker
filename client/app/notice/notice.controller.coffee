'use strict'

angular.module('mauiApp')

.controller 'NoticeCtrl', (
  $scope
  $state
  Restangular
  Msg
) ->

  angular.extend $scope,
    pageConf:
      itemsPerPage: 10
      currentPage : $state.params.page ? 1
      maxSize: 5

    noticeStatus: if $state.is('notices.read') then 1 else 0

    messages: []

    markAsRead: (message, $event)->
      $event?.stopPropagation()
      if message.raw.status
        return
      noticeId = message.raw._id
      Restangular.all('notices/read').post ids:[noticeId]
      .then ()->
        message.raw.status = 1
        Msg.readMsg()

    changePage: ()->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  Restangular.all('notices').getList(
    all: true
    from   : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit  : $scope.pageConf.itemsPerPage
    status : $scope.noticeStatus
  )
  .then (notices)->
    $scope.messages = []
    notices.forEach (notice)->
      if notice.data?
        if notice.data.articleId? or notice.data.courseId? or notice.data.commentId?
          $scope.messages.push Msg.genMessage(notice)
      else
        $scope.messages.push Msg.genMessage(notice)
    $scope.messages.$count = notices.$count
    $scope.$emit 'updateTitle', ->
      count = $scope.messages.$count ? 0
      if $state.is('notices.read')
        '已读消息 (' + count + ')'
      else
        '未读消息 (' + count + ')'



