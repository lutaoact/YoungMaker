'use strict'

angular.module('budweiserApp').controller 'CategoryManagerCourseDetailCtrl', (
  $scope
  $state
  chartUtils
  Restangular
) ->

  angular.extend $scope,
    $state: $state
    course: null

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
    console.debug course
    chartUtils.genStatsOnScope($scope, course._id, course.owners[0]._id)