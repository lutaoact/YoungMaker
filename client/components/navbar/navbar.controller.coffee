'use strict'

angular.module('budweiserApp').controller 'NavbarCtrl',
(
  Auth
  $scope
  $state
  socket
  $location
) ->

  angular.extend $scope,

    menu: [
      {
        title: '主页'
        link: 'teacher.home'
        role: 'teacher'
      }

      {
        title: '管理组'
        link: 'admin.classeManager'
        role: 'admin'
      }
    ]

    isCollapsed: true
    isLoggedIn: Auth.isLoggedIn
    getCurrentUser: Auth.getCurrentUser

    logout: ->
      Auth.logout()
      $location.path '/login'
      socket.close()

    isActive: (route) ->
      route is $state.current.name
