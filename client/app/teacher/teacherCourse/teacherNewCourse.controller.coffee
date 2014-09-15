'use strict'

angular.module('budweiserApp').controller 'TeacherNewCourseCtrl', (
  $scope
  Courses
  Categories
) ->

  angular.extend $scope,
    courses: Courses
    categories: Categories
    course: {}
    editing: true

