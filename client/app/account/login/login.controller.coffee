'use strict'

angular.module('budweiserApp').controller 'LoginCtrl', ($scope, Auth, $location, $window, LoginRedirector) ->

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

    loginOauth: (provider) ->
      $window.location.href = '/auth/' + provider

    testLoginUsers: [
      name:'Default'
      email:'test@test.com'
      password: 'test'
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
