'use strict'

angular.module 'maui.components'

.controller 'NavbarCtrl', (
  Msg
  Auth
  $scope
  $state
  socket
) ->

  angular.extend $scope,

    $state: $state
    viewState:
      isCollapsed: true
    messages: Msg.messages
    isLoggedIn: Auth.isLoggedIn
    getMsgCount: Msg.getMsgCount

    switchMenu: (val) ->
      $scope.viewState.isCollapsed = val

    logout: ->
      Msg.clearMsg()
      Auth.logout()
      socket.close()

    isActive: (route) ->
      route?.replace(/\(.*?\)/g, '') is $state.current.name

  $scope.$watch 'me', (me)->
    if me._id?
      Msg.init()
