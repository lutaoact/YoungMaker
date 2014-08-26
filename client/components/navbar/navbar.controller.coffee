'use strict'

angular.module('budweiserApp').controller 'NavbarCtrl', ($scope, $location, Auth) ->

  angular.extend $scope,

    menu: [
      {
        title: '主页'
        link: 'teacher.home'
        role: 'teacher'
      }
      {
        title: '主页'
        link: 'student'
        role: 'student'
      }
      {
        title: '课程'
        link: 'student.coursesList'
        role: 'student'
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

    isActive: (route) ->
      route is $location.path()
