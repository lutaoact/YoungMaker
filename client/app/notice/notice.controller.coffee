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
      itemsPerPage: 5
      currentPage : $state.params.page ? 1
      read: $state.params.read
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
        read: if $state.params.read then true else false

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


