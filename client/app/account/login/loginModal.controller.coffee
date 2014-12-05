'use scrict'

angular.module('mauiApp').controller 'loginModalCtrl', (
  $scope,
  $modal,
  Auth,
  notify,
  $modalInstance
) ->

  angular.extend $scope,
#    email: email
#    emailHostAddress: mailAddressService.getAddress email
#    viewState:
#      sending: false
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
          $scope.$emit 'loginSuccess', me
      , (error)->
        console.debug error
        $scope.loggingIn = false

        if error.unactivated
          $modal.open
            templateUrl: 'app/directives/loginForm/activateModal.html'
            controller: 'ActivateModalCtrl'
            windowClass: 'center-modal'
            size: 'sm'
            resolve:
              email: -> $scope.user.email
          .result.then () ->
            notify
              message: "一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
              classes: 'alert-success'
              duration: 10000

        else
          notify
            message:'用户名或密码错误'
            classes:'alert-danger'