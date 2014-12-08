'use scrict'

angular.module('mauiApp').controller 'loginModalCtrl', (
  $scope,
  $modal,
  Auth,
  notify,
  $modalInstance,
  Restangular
) ->

  angular.extend $scope,
#    email: email
#    emailHostAddress: mailAddressService.getAddress email
#    viewState:
#      sending: false
    currentPage: "login"
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
        Auth.getCurrentUser().$promise.then (me)->
          $scope.loggingIn = false
#          $scope.$emit 'loginSuccess', me
          $modalInstance.close()
      , (error)->
        console.debug error
        $scope.loggingIn = false
        notify
          message:'用户名或密码错误'
          classes:'alert-danger'

    signup: (form) ->
      if !form.$valid then return
      # Account created, redirect to home
      Restangular.all('users').post
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
      .then ->
        $modalInstance.close()
      .catch (err) ->
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message