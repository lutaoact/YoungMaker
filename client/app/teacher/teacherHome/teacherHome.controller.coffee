'use strict'

angular.module('mauiApp').controller 'TeacherHomeCtrl', (
  Auth
  $scope
) ->

  angular.extend $scope,
    auth: Auth
