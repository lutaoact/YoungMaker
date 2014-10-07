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
) ->

  angular.extend $scope,

    isCollapsed: true
    isLoggedIn: Auth.isLoggedIn
    getCurrentUser: Auth.getCurrentUser
    messages: Msg.messages
    getTitle: Navbar.getTitle

    logout: ->
      $state.go(if $state.current?.name == 'test' then 'test' else 'main')
      .then ->
        Auth.logout()
        socket.close()

    login: ->
      if $state.current?.name == 'test'
        loginRedirector.set($state.href($state.current, $state.params))
      else
        $state.go('login')

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

  genMessage = (raw)->
    switch raw.type
      when Const.NoticeType.TopicVoteUp
        title: raw.fromWhom + '赞了你的帖子：' + raw.data.disTopic
        link: ''
      when Const.NoticeType.ReplyVoteUp
        title: raw.fromWhom + '赞了你的回复：' + raw.data.disReply.content
        link: ''
      when Const.NoticeType.Comment
        title: raw.fromWhom + '回复了你的帖子：' + raw.data.disTopic
        link: ''
      when Const.NoticeType.Lecture
        title: raw.fromWhom + '发布了新课时' + raw.data.lecture
        link: ''
      else {}

  $scope.$on 'message.notice', (event, data)->
    $scope.messages.splice 0, 0, genMessage(data)
    console.log $scope.messages


