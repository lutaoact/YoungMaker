'use strict'

angular.module('budweiserApp').controller 'TeacherQuestionLibraryCtrl', (
  $scope
  $state
  Navbar
  Courses
  KeyPoints
  Categories
) ->

  course = _.find Courses, _id:$state.params.courseId
  category = _.find Categories, _id:course.categoryId

  Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,
    course: course
    category: category
    keyPoints: KeyPoints

