'use scrict'

angular.module('mauiApp').controller 'loginModalCtrl', (
  $scope,
  $modal,
  Auth,
  notify,
  $modalInstance,
  Restangular,
  $timeout
) ->

  angular.extend $scope,
    currentPage: "login"
    checkEmailPromise: null

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
#        Auth.getCurrentUser().$promise.then (me)->
#          $scope.$emit 'loginSuccess', me
        $scope.loggingIn = false
        $modalInstance.close()
      , (error)->
        console.debug error
        $scope.loggingIn = false
        notify
          message:'用户名或密码错误'
          classes:'alert-danger'

    signup: (form) ->
      if !form.$valid then return
      Restangular.all('users').post
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
      .then (res)->
        Auth.setToken res.token
#        Auth.getCurrentUser().$promise.then (me)->
#          $scope.$emit 'loginSuccess', me
        $modalInstance.close()
      .catch (err) ->
        console.log err
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

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