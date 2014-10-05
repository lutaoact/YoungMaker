'use strict'

angular.module('budweiserApp').controller 'TeacherCtrl', (
  $scope
  $state
) ->

  angular.extend $scope,
    $state: $state


