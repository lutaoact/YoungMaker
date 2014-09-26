'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  Auth
  $modal
  $scope
  Courses
  Categories
  Restangular
  timetableHelper
) ->

  angular.extend $scope,

    courses: Courses

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        size: 'lg'
        resolve:
          categories: -> Categories
      .result.then (newCourse) ->
        $scope.courses.push newCourse
