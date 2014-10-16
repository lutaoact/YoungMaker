'use strict'

angular.module('budweiserApp').controller 'LoginCtrl', (
  Auth
  $scope
  $window
  $location
  socketHandler
  loginRedirector
  $state
  $localStorage
) ->
  $localStorage.global ?= {}
  $localStorage.global.loginState = $state.current.name
  $localStorage.global.loginPath = $state.current.url
  angular.extend $scope,
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
            socketHandler.init(me)
            if !loginRedirector.apply()
              if me.role is 'admin'
                $location.url('/a')
              else if me.role is 'teacher'
                $location.url('/t')
              else if me.role is 'student'
                $location.url('/s')
              $location.replace()
        .catch (err) ->
          $scope.errors.other = err.message

    loginOauth: (provider) ->
      $window.location.href = '/auth/' + provider

    testLoginUsers: [
      name:'Student'
      username:'student@student.com'
      password: 'student'
    ,
      name:'Teacher'
      username:'teacher@teacher.com'
      password: 'teacher'
    ,
      name:'Admin'
      username:'admin@admin.com'
      password: 'admin'
    ]

    setLoginUser: ($event, form, user) ->
      $scope.user = user
      $scope.login(form) if $event.metaKey
