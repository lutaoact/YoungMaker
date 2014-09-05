angular.module('budweiserApp').controller 'StudentQuickNavCtrl', (
  $scope
  $modalInstance
  notify
  otherCourses
) ->
  angular.extend $scope,
    close: ->
      $modalInstance.dismiss('close')

    viewState: {}

    otherCourses: otherCourses


