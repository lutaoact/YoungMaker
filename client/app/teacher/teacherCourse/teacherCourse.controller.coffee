'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  Restangular
) ->

  angular.extend $scope,

    courses: []

  Restangular.all('courses').getList()
  .then (courses)->
    $scope.courses = courses

