'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  User
  Auth
  $http
  $state
  $scope
  $upload
  Courses
) ->

  angular.extend $scope,

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses

    startCourse: (event)->
      $state.go 'student.courseDetail', courseId: event.$course._id

  $scope.loadCourses()
