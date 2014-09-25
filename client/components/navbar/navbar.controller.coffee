'use strict'

angular.module('budweiserApp').controller 'NavbarCtrl',
(
  Auth
  $scope
  $state
  socket
  $location
  loginRedirector
  $rootScope
  Msg
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

    generateAdditionalMenu: ()->
      switch true
        when /^(teacher|forum|student).(course|lecture|topic|questionLibrary)/.test $state.current.name
          $scope.additionalMenu = [
            {
              title: '课程主页'
              link: "student.courseDetail({courseId:'#{$state.params.courseId}'})"
              role: 'student'
            }
            {
              title: '课程主页'
              link: "teacher.course({courseId:'#{$state.params.courseId}'})"
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

    decideNavColor: ()->
      $scope.navInSub = /^(teacher|forum|student).(course|lecture|topic|questionLibrary)/.test $state.current.name

    messages: Msg.messages

  $scope.generateAdditionalMenu()
  $scope.decideNavColor()

  $scope.$on '$stateChangeSuccess', (event, value)->
    $scope.generateAdditionalMenu()
    $scope.decideNavColor()

  genMessage = (raw)->
    message = {}
    switch raw.type
      when Const.NoticeType.TopicVoteUp
        message =
          title: raw.fromWhom + '赞了你的帖子：' + raw.data.disTopic
          link: ''
      when Const.NoticeType.ReplyVoteUp
        message =
          title: raw.fromWhom + '赞了你的回复：' + raw.data.disTopic
          link: ''
      when Const.NoticeType.Comment
        message =
          title: raw.fromWhom + '回复了你的帖子：' + raw.data.disTopic
          link: ''
      when Const.NoticeType.Lecture
        message =
          title: raw.fromWhom + '发布了新课时' + raw.data.lecture
          link: ''

    message

  $scope.$on 'message.notice', (event, data)->
    $scope.messages.splice 0, 0, genMessage(data)


