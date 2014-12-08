'use scrict'

angular.module('mauiApp').controller 'loginModalCtrl', (
  $scope,
  $modal,
  Auth,
  notify,
  $modalInstance,
  Restangular,
  $timeout,
  $interval
) ->
  maxTimeout = 15
  angular.extend $scope,
    currentPage: "login"
    checkEmailPromise: null
    viewState:
      init: true
      sending: false
      sent: false
      errors: null

    changePage: (pageName)->
      $scope.currentPage = pageName
    user: {}
    errors: {}
    login: (form) ->
      if !form.$valid then return
      $scope.loggingIn = true
      # Logged in, redirect to home
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then ->
        $scope.loggingIn = false
        $modalInstance.close()
      , (error)->
        console.debug error
        $scope.loggingIn = false
        $scope.viewState.errors =
          data: "用户名或密码错误"

    signup: (form) ->
      if !form.$valid then return
      Restangular.all('users').post
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
      .then (res)->
        Auth.setToken res.token
        $modalInstance.close()
      .catch (err) ->
        console.log err
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

    sendVerifyEmail: (form) ->
      if !form.$valid then return
      $scope.viewState.init = false
      $scope.viewState.sending = true
      $scope.viewState.errors = null
      Restangular.all('users').customPOST(email:$scope.user.email, 'forgotPassword')
      .then ->
        $scope.viewState.sent = true
        $scope.viewState.sending = false
        countTimeout()
      .catch (errors) ->
        $scope.viewState.sending = false
        $scope.viewState.errors = errors

    checkEmail: (email)->
      $timeout.cancel($scope.checkEmailPromise)
      if email.$modelValue
        email.$remoteChecked = 'pending'
        email.$setValidity 'remote', true
        $scope.checkEmailPromise = $timeout ->
          Restangular.one('users','check').get(email: email.$modelValue)
          .then (data)->
            email.$setValidity 'remote', true
            email.$remoteChecked = true
          , (err)->
            email.$setValidity 'remote', false
            email.$remoteChecked = false
        , 800

    timeout: 0
    countTimeout = ->
      $scope.timeout = maxTimeout
      $interval ->
        $scope.timeout -= 1
      , 1000, maxTimeout