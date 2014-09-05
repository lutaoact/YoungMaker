'use strict'

angular.module('budweiserApp')

.factory 'SockJSClient', ->

  sockJs = undefined

  setup : (userId, role) ->
    console.debug 'Setup sockjs connect... '
    sockJs = new SockJS '/sockjs'
    sockJs.onopen = ->
      msg =
        type : 'login'
        payload:
          userId : userId
          role : role
      sockJs.send JSON.stringify msg

  get : -> sockJs

  send : (msg) ->
    sockJs.send(msg)

.controller 'LoginCtrl', ($scope, Auth, $location, $window, LoginRedirector, SockJSClient) ->

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
                console.debug 'data is ', data

                SockJSClient.setup(data._id, data.role)

        .catch (err) ->
          $scope.errors.other = err.message

    loginOauth: (provider) ->
      $window.location.href = '/auth/' + provider

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
