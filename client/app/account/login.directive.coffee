angular.module('mauiApp')

.directive 'loginWindow', (
  Auth
  $modal
) ->

  restrict: 'A'

  scope:
    loginSuccess: '&'

  link: (scope, element)->
    element.bind 'click', ()->
      if !Auth.isLoggedIn()
        $modal.open
          templateUrl: 'app/account/loginModal.html'
          controller: 'loginModalCtrl'
          windowClass: 'center-modal'
        .result.then ->
          scope.loginSuccess?()
      else
        scope.loginSuccess?()
