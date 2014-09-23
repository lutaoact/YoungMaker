'use strict'

angular.module('budweiserApp').controller 'StudentCourseStatsCtrl', (
  Auth
  $scope
  $state
  Restangular
  chartUtils
) ->

  chartUtils.genStatsOnScope $scope, $state.params.courseId

  angular.extend $scope,
    student: Auth.getCurrentUser()
