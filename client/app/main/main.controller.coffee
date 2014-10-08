'use strict'

angular.module('budweiserApp').controller 'MainCtrl',
(
  Msg
  $scope
  $http
  Auth
  $state
  $location
  socketHandler
  loginRedirector
  notify
) ->

  angular.extend $scope,
    menu: [
      {
        title: '主页'
        link: 'teacher.home'
        role: 'teacher'
      }
      {
        title: '主页'
        link: 'student.home'
        role: 'student'
      }
      {
        title: '管理组'
        link: 'admin.classeManager'
        role: 'admin'
      }
    ]

    isActive: (route) ->
      route is $state.current.name

    user: {}

    errors: {}

    login: (form) ->
      $scope.submitted = true

      if form.$valid
        # Logged in, redirect to home
        Auth.login(
          username: $scope.user.username
          password: $scope.user.password
        ).then ->
          Auth.getCurrentUser().$promise.then (me)->
            Msg.init()

            socketHandler.init(me)
            if !loginRedirector.apply()
              if me.role is 'admin'
                $location.url('/admin')
              else if me.role is 'teacher'
                $location.url('/t')
              else if me.role is 'student'
                $location.url('/s')
              $location.replace()
        , (err)->
          notify
            message:'用户名或密码错误'
            template:'components/alert/failure.html'

    loginOauth: (provider) ->
      $window.location.href = '/auth/' + provider



