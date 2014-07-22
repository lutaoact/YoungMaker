'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', ($scope,$state,Restangular,Auth, $http,$upload,$location) ->
  $scope.message = 'Hello'
  $scope.courses = []
  Restangular.all('courses').getList()
  .then (courses)->
    $scope.courses = courses

