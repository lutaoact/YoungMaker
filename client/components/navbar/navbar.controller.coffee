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
    deferred = $q.defer()
    switch raw.type
      when Const.NoticeType.TopicVoteUp
        deferred.resolve
          title: '赞了你的帖子：' + raw.data.disTopic.title
          raw: raw
          link: "forum.topic({courseId:'#{raw.data.disTopic.courseId}',topicId:'#{raw.data.disTopic._id}'})"
          type: 'message'
      when Const.NoticeType.ReplyVoteUp
        Restangular.one('dis_topics', raw.data.disReply.disTopicId).get()
        .then (topic)->
          raw.data.disTopic = topic
          deferred.resolve
            title: '赞了你的回复：' + raw.data.disReply.content
            raw: raw
            link: "forum.topic({courseId:'#{topic.courseId}',topicId:'#{raw.data.disReply.disTopicId}'})"
            type: 'message'
      when Const.NoticeType.Comment
        deferred.resolve
          title: '回复了你的帖子：' + raw.data.disTopic.title
          raw: raw
          link: "forum.topic({courseId:'#{raw.data.disTopic.courseId}',topicId:'#{raw.data.disTopic._id}'})"
          type: 'message'

      else deferred.reject()
    deferred.promise

  $scope.$on '$stateChangeSuccess', (event, state, params)->
    if params.hasOwnProperty 'topicId'
      toRemove = $scope.messages.filter (x)-> x.raw.data.disTopic._id is params.topicId
      toRemove?.forEach (message)->
        $scope.messages.splice $scope.messages.indexOf(message), 1

  $scope.$on 'message.notice', (event, data)->
    genMessage(data).then (msg)->
      $scope.messages.splice 0, 0, msg


