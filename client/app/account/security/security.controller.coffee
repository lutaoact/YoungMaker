'use strict'

angular.module('budweiserApp').controller 'SecurityCtrl', ($scope, User, Auth, Restangular,$http,$upload) ->
  angular.extend $scope,
    errors: {}

    changePassword: (form) ->
      $scope.submitted = true

      if form.$valid
        Auth.changePassword($scope.user.oldPassword, $scope.user.newPassword).then(->
          $scope.message = 'Password successfully changed.'
        ).catch ->
          form.password.$setValidity 'mongoose', false
          $scope.errors.other = 'Incorrect password'
          $scope.message = ''

