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
      Auth.logout()
      $state.go if $state.current?.name == 'test' then 'test' else 'main'
      socket.close()

    login: ->
      if $state.current?.name == 'test'
        loginRedirector.set($state.href($state.current, $state.params))
      else
        $state.go('login')

    isActive: (route) ->
      route?.replace(/\(.*?\)/g, '') is $state.current.name

  generateAdditionalMenu = ->
    $scope.navInSub = /^(teacher|forum|student).(course|lecture|topic|questionLibrary)/.test $state.current.name
    if $scope.navInSub
      $scope.additionalMenu = [
        {
          title: '管理组'
          link: 'admin.classeManager'
          role: 'admin'
        }
        {
          title: '题库'
          link: "teacher.questionLibrary({courseId:'#{$state.params.courseId}'})"
          role: 'teacher'
        }
        {
          title: '讨论'
          link: "forum.course({courseId:'#{$state.params.courseId}'})"
          role: 'student'
        }
        {
          title: '讨论'
          link: "forum.course({courseId:'#{$state.params.courseId}'})"
          role: 'teacher'
        }
        {
          title: '统计'
          link: "student.courseStats({courseId:'#{$state.params.courseId}'})"
          role: 'student'
        }
        {
          title: '统计'
          link: "teacher.courseStats.all({courseId:'#{$state.params.courseId}'})"
          role: 'teacher'
        }
      ]
    else
      $scope.additionalMenu = []

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


