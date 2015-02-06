'use strict'

angular.module('mauiApp')

.controller 'ResetCtrl', (
  $scope
  $state
  notify
  Restangular
) ->

  angular.extend $scope,
    viewState:
      resetting: false
      reseted: false
      errors: null
    password: ''

    resetPassword: (form) ->
      if !form.$valid then return
      $scope.viewState.resetting = true
      $scope.viewState.errors = null
      data = angular.extend $state.params,
        password: $scope.password
      Restangular.all('users').customPOST(data, 'resetPassword')
      .then ->
        $scope.viewState.reseted = true
      .catch (errors) ->
        $scope.viewState.errors = errors
      .finally ->
        $scope.viewState.resetting = false

    checkPasswordAgain: (password, passwordAgain) ->
      passwordVal = password.$modelValue
      passwordAgainVal = passwordAgain.$modelValue
      passwordAgain.$setValidity 'sameWith', !passwordAgainVal || passwordAgainVal == passwordVal
