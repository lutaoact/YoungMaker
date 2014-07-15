'use strict'

angular.module('budweiserApp').controller 'LoginCtrl', ($scope, Auth, $location, $window) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then(() ->
        if $location.search().r?
          $location.url(encodeURIComponent($location.search().r))
          $location.replace()
        else
          $location.url('/')
          $location.replace()
      ).catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
