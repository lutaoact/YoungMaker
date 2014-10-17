angular.module('budweiserApp').controller 'StudentQuickNavCtrl', (
  $scope
  $modalInstance
  otherCourses
) ->
  angular.extend $scope,
    close: ->
      $modalInstance.dismiss('close')

    viewState: {}

    otherCourses: otherCourses

  # Fix bug: the popup does not dismiss when change state
  # http://stackoverflow.com/questions/14898296/how-to-unsubscribe-to-a-broadcast-event-in-angularjs-how-to-remove-function-reg
  $scope.$on '$stateChangeSuccess', $scope.close


