'use strict'

angular.module('budweiserApp').controller 'LoginCtrl', ($scope, Auth, $location, $window, LoginRedirector) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then (me) ->
        Auth.getCurrentUser().$promise.then ()->
          if !LoginRedirector.apply()
            me.$promise.then (data)->
              if data.role is 'admin'
                $location.url('/admin')
              else if data.role is 'teacher'
                $location.url('/t')
              else if data.role is 'student'
                $location.url('/s')
              $location.replace()
      .catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
