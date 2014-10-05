'use strict'

angular.module('budweiserApp').controller 'TeacherQuestionLibraryCtrl', (
  $scope
  $state
  Courses
  KeyPoints
  Categories
) ->

  course = _.find Courses, _id:$state.params.courseId
  category = _.find Categories, _id:course.categoryId

  angular.extend $scope,
    course: course
    category: category
    keyPoints: KeyPoints

