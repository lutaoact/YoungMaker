'use strict'

angular.module('mauiApp').controller 'LoginCtrl', (
  Auth
  $state
  $scope
  $window
  $location
  socketHandler
  $localStorage
  loginRedirector
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
            $scope.$emit 'loginSuccess', me
        .catch (err) ->
          $scope.errors.other = err.message

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
