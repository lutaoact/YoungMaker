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

    isActive: (state) ->
      if state
        regex = new RegExp(state)
        regex.test $state.current.name
      else
        false

  $scope.$watch 'me', (me)->
    if me._id?
      Msg.init()
