'use strict'

angular.module('mauiApp').directive 'loginForm', ->
  templateUrl: 'app/directives/loginForm/loginForm.html'
  restrict: 'E'
  replace: true

  controller: (
    Msg
    Auth
    $scope
    $state
    notify
    $location
    socketHandler
    $localStorage
  ) ->

    angular.extend $scope,
      user: {}
      errors: {}

      login: (form) ->
        $scope.loggingIn = true
        if !form.$valid then return
        # Logged in, redirect to home
        Auth.login(
          username: $scope.user.username
          password: $scope.user.password
        ).then ->
          Auth.getCurrentUser().$promise.then (me)->
            $scope.loggingIn = false
            $scope.$emit 'loginSuccess', me
        , (error)->
          console.debug error
          $scope.loggingIn = false
          notify
            message:'用户名或密码错误'
            classes:'alert-danger'
