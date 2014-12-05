'use strict'

angular.module 'maui.components'

.factory 'Navbar', ->
  title = null
  getTitle: -> title
  setTitle: (name, link) ->
    title =
      name: name
      link: link
  resetTitle: ->
    title = null

.controller 'NavbarCtrl', (
  Msg
  Auth
  $scope
  $state
  Navbar
  socket
  $rootScope
  Restangular
  $localStorage
) ->

  angular.extend $scope,

    $state: $state
    viewState:
      isCollapsed: true
    messages: Msg.messages
    getTitle: Navbar.getTitle
    getVisible: Navbar.getVisible
    isLoggedIn: Auth.isLoggedIn
    getCurrentUser: Auth.getCurrentUser

    switchMenu: (val) ->
      $scope.viewState.isCollapsed = val

    logout: ->
      Auth.logout()
      socket.close()
      $state.go('main')

    isActive: (route) ->
      route?.replace(/\(.*?\)/g, '') is $state.current.name

    clearAll: ()->
      if $scope.messages.length
        Restangular.all('notices/read').post ids: _.map $scope.messages, (x)-> x.raw._id
        .then ()->
          $scope.messages.length = 0

    removeMsg: (message, $event)->
      # for only reload the topicDetail directive when we are just on this forum page.
      $rootScope.$broadcast("forum/reloadReplyList", message.raw.data?.disReply?._id)

      $event?.stopPropagation()
      noticeId = message.raw._id
      Restangular.all('notices/read').post ids:[noticeId]
      .then ()->
        $scope.messages.splice $scope.messages.indexOf(message), 1

  generateAdditionalMenu = ->
    mkMenu = (title, link) ->
      title: title
      link: link
    $scope.additionalMenu = []

  generateAdditionalMenu()
  $scope.$on '$stateChangeSuccess', generateAdditionalMenu

  $scope.$on 'message.notice', (event, data)->
    Msg.genMessage(data).then (msg)->
      $scope.messages.splice 0, 0, msg

