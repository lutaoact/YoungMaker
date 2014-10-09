'use strict'

angular.module('budweiserApp').directive 'loginForm', ->
  templateUrl: 'app/directives/loginForm/loginForm.html'
  restrict: 'E'
  replace: true
  link: (scope, element, attrs) ->

  controller: ($scope, Auth, $state, $location, socketHandler, loginRedirector, notify, Msg, $localStorage)->
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

