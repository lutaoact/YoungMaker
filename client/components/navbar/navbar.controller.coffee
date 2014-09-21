'use strict'

angular.module('budweiserApp').controller 'NavbarCtrl',
(
  Auth
  $scope
  $state
  socket
  $location
  loginRedirector
) ->

  angular.extend $scope,

    menu: [
      {
        title: '管理组'
        link: 'admin.classeManager'
        role: 'admin'
      }
    ]

    isCollapsed: true
    isLoggedIn: Auth.isLoggedIn
    getCurrentUser: Auth.getCurrentUser
    viewState:
      isOpen: false

    logout: ->
      Auth.logout()
      $state.go if $state.current?.name == 'test' then 'test' else 'login'
      socket.close()

    login: ->
      if $state.current?.name == 'test'
        loginRedirector.set($state.href($state.current, $state.params))
      else
        $state.go('login')

    isActive: (route) ->
      route.replace(/\(.*?\)/g, '') is $state.current.name


