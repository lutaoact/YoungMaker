'use strict'

angular.module('budweiserApp').controller 'StudentCourseStatsCtrl', (
  Auth
  Navbar
  $state
  $scope
  Courses
  chartUtils
) ->

  course = _.find Courses, _id:$state.params.courseId

  Navbar.setTitle course.name, "student.courseDetail({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  chartUtils.genStatsOnScope $scope, $state.params.courseId

  angular.extend $scope,
    student: Auth.getCurrentUser()
