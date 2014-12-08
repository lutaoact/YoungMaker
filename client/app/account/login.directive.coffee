angular.module('mauiApp').directive 'loginWindow', (
  $modal
) ->

  restrict: 'A'
  link: (scope, element)->
    element.bind 'click', ()->
      $modal.open
        templateUrl: 'app/account/loginModal.html'
        controller: 'loginModalCtrl'
        windowClass: 'center-modal'
