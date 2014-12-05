angular.module('mauiApp').directive 'loginWindow', (
  $modal
) ->

  restrict: 'A'
  link: (scope, element)->
    element.bind 'click', ()->
      $modal.open
        templateUrl: 'app/account/login/loginModal.html'
        controller: 'loginModalCtrl'
        windowClass: 'center-modal'

#      resolve:
#        email: -> $scope.user.email
#      .result.then () ->
#        notify
#          message: "一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
#          classes: 'alert-success'
#          duration: 10000