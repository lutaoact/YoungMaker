'use strict'

angular.module('mauiApp').controller 'LoginCtrl', (
  Auth
  $state
  $scope
) ->

  angular.extend $scope,
    user: {}
    errors: {}
    login: (form) ->
      $scope.submitted = true

      if form.$valid
        # Logged in, redirect to home
        Auth.login(
          email: $scope.user.email
          password: $scope.user.password
        ).then ->
          Auth.getCurrentUser().$promise.then (me)->
            $scope.$emit 'loginSuccess', me
        .catch (err) ->
          $scope.errors.other = err.message

    testLoginUsers: [
      name:'Student'
      email:'student@student.com'
      password: 'student'
    ,
      name:'Teacher'
      email:'teacher@teacher.com'
      password: 'teacher'
    ,
      name:'Admin'
      email:'admin@admin.com'
      password: 'admin'
    ]

    setLoginUser: ($event, form, user) ->
      $scope.user = user
      $scope.login(form) if $event.metaKey
