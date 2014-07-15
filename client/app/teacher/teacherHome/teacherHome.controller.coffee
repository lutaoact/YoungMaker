'use strict'

angular.module('budweiserApp').controller 'TeacherhomeCtrl', ($scope) ->
  $scope.courses = [
    {
      name:'高数'
      info:'三角函数，微积分'
      _id:2
    }
    {
      name:'物理'
      info:'三角函数，微积分'
      _id:3
    }
    {
      name:'化学'
      info:'三角函数，微积分'
      _id:1
    }
    {
      name:'大学英语'
      info:'三角函数，微积分'
      _id:4
    }
  ]
