'use strict'

angular.module('budweiserApp')

.controller 'TeacherManagerDetailCtrl', (
  $state
  $scope
  chartUtils
  Restangular
) ->

  resetSelectedCourse = ->
    selectedCourse = _.find($scope.courses, _id:$scope.selectedCourse?._id) ? $scope.courses?[0]
    angular.extend $scope.selectedCourse, selectedCourse
    if selectedCourse?
      chartUtils.genStatsOnScope($scope, selectedCourse?._id, $scope.teacher?._id)

  angular.extend $scope,
    $state: $state
    courses: null
    selectedCourse: {}

    updateTeacher: ->
      $scope.reloadTeachers()

    deleteTeacher: ->
      $scope.reloadTeachers()
      $state.go('admin.teacherManager')

  Restangular.one('users', $state.params.teacherId).get()
  .then (teacher) ->
    $scope.teacher = teacher

  Restangular.all('courses').getList(teacherId: $state.params.teacherId)
  .then (courses) ->
    $scope.courses = courses
    resetSelectedCourse()

  $scope.$watch 'selectedCourse._id', resetSelectedCourse

