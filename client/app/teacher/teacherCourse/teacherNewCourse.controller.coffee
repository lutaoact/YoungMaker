'use strict'

angular.module('budweiserApp').controller 'TeacherNewCourseCtrl', (
  Auth
  $scope
  categories
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    categories: categories
    course:
      owners: [Auth.getCurrentUser()]

    onThumbUploaded: (key) ->
      $scope.course.thumbnail = key

    close: ->
      $modalInstance.dismiss('cancel')

    confirmCreate: (course, form) ->
      unless form.$valid then return
      Restangular.all('courses').post(course)
      .then (newCourse)->
        $modalInstance.close(newCourse)
