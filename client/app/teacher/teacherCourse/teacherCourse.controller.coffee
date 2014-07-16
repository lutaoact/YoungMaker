'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', ($scope) ->
  $scope.message = 'Hello'

.controller 'TeacherCourseNewCtrl', ($scope) ->
  $scope.message = 'Hello'
  $scope.categories = [
    {
      _id:1
      name:'高一数学'
    }
    {
      _id:2
      name:'高二数学'
    }
    {
      _id:3
      name:'高三数学'
    }
    {
      _id:4
      name:'高一物理'
    }
    {
      _id:5
      name:'高二物理'
    }
    {
      _id:6
      name:'高三物理'
    }
  ]
