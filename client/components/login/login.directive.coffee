angular.module('maui.components')

.directive 'loginWindow', (
  Auth
  $modal
) ->

  restrict: 'A'

  scope:
    loginSuccess: '&'
    mode: '@'

  link: (scope, element)->
    element.bind 'click', ()->
      if !Auth.isLoggedIn()
        $modal.open
          templateUrl: 'components/login/loginModal.html'
          controller: 'loginModalCtrl'
          windowClass: 'login-window-modal'
          resolve:
            mode: -> scope.mode ? 'login'
        .result.then ->
          scope.loginSuccess?()
      else
        scope.loginSuccess?()
