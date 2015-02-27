'use strict'

angular.module('mauiApp')

.controller 'ForgotCtrl', (
  $scope
  $state
  $interval
  Restangular
  $localStorage
) ->

  maxTimeout = 15
  angular.extend $scope,
    email: $localStorage.user?.email
    errors: null
    timeout: maxTimeout
    viewState:
      sending: false
      sended: false
      errors: null

    sendVerifyEmail: (form) ->
      if !form.$valid then return
      $scope.viewState.sending = true
      $scope.viewState.errors = null
      Restangular.all('users').customPOST(email:$scope.email, 'forgotPassword')
      .then ->
        $scope.viewState.sending = false
        $scope.viewState.sended = true
        countTimeout()
      .catch (errors) ->
        $scope.viewState.errors = errors
        $scope.viewState.sending = false

  countTimeout = ->
    $scope.timeout = maxTimeout
    $interval ->
      $scope.timeout -= 1
    , 1000, maxTimeout
