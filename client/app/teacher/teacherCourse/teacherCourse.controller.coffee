'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $http
  $scope
  $state
  Classes
  $upload
  fileUtils
  Categories
  Restangular
) ->

  loadCourse = ->
    if $state.params.courseId is 'new'
      $scope.course = {}
    else
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        console.debug 'load course', course
        $scope.course = course

  angular.extend $scope,
    $state: $state
    categories: Categories
    course: undefined

  loadCourse()

