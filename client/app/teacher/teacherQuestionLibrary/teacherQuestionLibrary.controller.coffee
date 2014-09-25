'use strict'

angular.module('budweiserApp').controller 'TeacherQuestionLibraryCtrl', (
  $scope
  $state
  Courses
  Categories
  Restangular
) ->

  course = _.find Courses, _id:$state.params.courseId
  category = _.find Categories, _id:course.categoryId

  angular.extend $scope,
    course: course
    category: category
    keyPoints: Restangular.all('key_points').getList(categoryId:course.categoryId)

