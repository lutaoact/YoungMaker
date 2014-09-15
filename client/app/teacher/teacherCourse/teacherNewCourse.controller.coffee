'use strict'

angular.module('budweiserApp').controller 'TeacherNewCourseCtrl', (
  Auth
  $scope
  Courses
  Categories
) ->

  angular.extend $scope,
    courses: Courses
    categories: Categories
    course:
      owners:[Auth.getCurrentUser()]
    editing: true

