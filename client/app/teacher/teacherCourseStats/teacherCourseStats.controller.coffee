'use strict'

angular.module('budweiserApp').controller 'TeacherCourseStatsCtrl', (
  $q
  $scope
  $state
  Navbar
  Courses
  Restangular
  $timeout
  $window
) ->

  course = _.find Courses, _id:$state.params.courseId

  Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,
    course: course
    classes: course.classes
    viewState: {}

    triggerResize: ()->
      # trigger to let the chart resize
      $timeout ->
        angular.element($window).resize()

    viewStudentStats: (student)->
      console.log 'viewStudentStats'
      $state.go 'teacher.courseStats.student',
        courseId: $scope.course._id
        studentId: student._id or student

.controller 'TeacherCourseStatsMainCtrl', (
  $scope
  $state
  chartUtils
) ->
  $scope.viewState.student = undefined

  chartUtils.genStatsOnScope $scope, $state.params.courseId

.controller 'TeacherCourseStatsStudentCtrl', (
  $scope
  $state
  chartUtils
) ->

  chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.studentId



