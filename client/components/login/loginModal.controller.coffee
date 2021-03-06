'use scrict'

angular.module('maui.components')

.controller 'loginModalCtrl', (
  Auth
  focus
  $state
  $scope
  notify
  $modal
  $timeout
  Restangular
  $localStorage
  $modalInstance
  mode
) ->

  checkEmailPromise = null

  angular.extend $scope,
    user: angular.copy($localStorage.user) ? {}
    currentPage: mode ? 'login'
    viewState:
      posting: false
      errors: null

    cancel: ->
      $modalInstance.dismiss('cancel')

    changePage: (pageName) ->
      if pageName == 'forget'
        $modalInstance.dismiss('cancel')
        $state.go('forgot')
        return
      $scope.currentPage = pageName
      inputName =
        if pageName isnt 'login'
          'nameInput'
        else if $scope.user.email
          'passwordInput'
        else
          'emailInput'
      focus inputName

    login: (form) ->
      if !form.$valid then return
      $scope.viewState.posting = true
      $scope.viewState.errors = null
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then (me) ->
        $modalInstance.close()
        $scope.viewState.posting = false
      .catch (error) ->
        $scope.viewState.errors = error
        $scope.viewState.posting = false

    signup: (form) ->
      if !form.$valid then return
      $scope.viewState.posting = true
      $scope.viewState.errors = null
      Restangular.all('users').post
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
      .then (res)->
        Auth.refreshCurrentUser()
        $scope.viewState.posting = false
        notify
          message: "注册成功"
          classes: 'alert-success'
        $modalInstance.close()
      .catch (err) ->
        $scope.viewState.posting = false
        $scope.viewState.errors = err?.data?.errors
        # Update validity of form fields that match the mongoose errors
        angular.forEach err?.data?.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false

    checkEmail: (email)->
      $timeout.cancel(checkEmailPromise)
      if email.$modelValue
        email.$remoteChecked = 'pending'
        email.$setValidity 'remote', true
        checkEmailPromise = $timeout ->
          Restangular.one('users','check').get(email: email.$modelValue)
          .then (data)->
            email.$setValidity 'remote', true
            email.$remoteChecked = true
          , (err)->
            email.$setValidity 'remote', false
            email.$remoteChecked = false
        , 800

  $scope.changePage( mode ? 'login')
