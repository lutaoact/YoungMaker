'use strict'

angular.module('mauiApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  Navbar
  Classes
  Courses
  $rootScope
  Categories
) ->

  course = _.find Courses, _id:$state.params.courseId

  Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,
    course: course
    classes: Classes
    categories: Categories

    deleteCallback: (course) ->
      Courses.splice(Courses.indexOf(course), 1)
      $state.go('teacher.home')
