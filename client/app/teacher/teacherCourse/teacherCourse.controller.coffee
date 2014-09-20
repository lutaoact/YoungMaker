'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  Classes
  Courses
  Categories
) ->

  angular.extend $scope,
    course: _.find Courses, _id:$state.params.courseId
    classes: Classes
    categories: Categories

    deleteCallback: (course) ->
      Courses.splice(Courses.indexOf(course), 1)
      $state.go('teacher.home')

