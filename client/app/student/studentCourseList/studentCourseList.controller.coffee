'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  User
  Auth
  $http
  $scope
  notify
  $upload
  Courses
  Restangular
  timetableHelper
) ->

  angular.extend $scope,

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses

    startCourse: (event)->
      console.log event

  $scope.loadCourses()
