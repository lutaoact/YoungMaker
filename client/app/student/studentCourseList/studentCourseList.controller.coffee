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
) ->

  angular.extend $scope,

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses


  $scope.loadCourses()
