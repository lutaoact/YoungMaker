'use strict'

angular.module 'budweiserApp'

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
  $location
  $rootScope
  loginRedirector
  $q
  Restangular
) ->

  angular.extend $scope,

    isCollapsed: true
    isLoggedIn: Auth.isLoggedIn
    getCurrentUser: Auth.getCurrentUser
    messages: Msg.messages
    getTitle: Navbar.getTitle

    logout: ->
      doLogout = ->
        Auth.logout()
        socket.close()
      $state.go('main').then doLogout

    isActive: (route) ->
      route?.replace(/\(.*?\)/g, '') is $state.current.name

  generateAdditionalMenu = ->
    mkMenu = (title, link) ->
      title: title
      link: link
    $scope.navInSub = /^(teacher|forum|student).(course|lecture|topic|questionLibrary)/.test($state.current.name)
    $scope.additionalMenu =
      if $scope.navInSub
        switch $scope.getCurrentUser()?.role
          when 'teacher'
            [
              mkMenu '题库', "teacher.questionLibrary({courseId:'#{$state.params.courseId}'})"
              mkMenu '讨论', "forum.course({courseId:'#{$state.params.courseId}'})"
              mkMenu '统计', "teacher.courseStats.all({courseId:'#{$state.params.courseId}'})"
            ]
          when 'student'
            [
              mkMenu '统计', "student.courseStats({courseId:'#{$state.params.courseId}'})"
              mkMenu '讨论', "forum.course({courseId:'#{$state.params.courseId}'})"
            ]
          when 'admin'
            [
              mkMenu '管理组', 'admin.classeManager'
            ]
          else []
      else []

  generateAdditionalMenu()
  $scope.$on '$stateChangeSuccess', generateAdditionalMenu
  
  $scope.$on 'message.notice', (event, data)->
    Msg.genMessage(data).then (msg)->
      $scope.messages.splice 0, 0, msg

  Auth.getCurrentUser().$promise?.then ->
    Restangular.all('notices').getList()
    .then (notices)->
      notices.forEach (notice)->
        genMessage(notice).then (msg)->
          $scope.messages.splice 0, 0, msg

  $scope.removeMsg = (message)->
    console.log message
    noticeId = message.raw._id
    Restangular.all('notices/read').post ids:[noticeId]
    .then ()->
      $scope.messages.splice $scope.messages.indexOf(message), 1

