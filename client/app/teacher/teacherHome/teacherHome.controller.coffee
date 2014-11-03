'use strict'

angular.module('mauiApp').controller 'TeacherHomeCtrl', (
  Auth
  $modal
  $state
  $scope
) ->

  angular.extend $scope,
    auth: Auth
