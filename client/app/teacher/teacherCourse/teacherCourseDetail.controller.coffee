'use strict'

angular.module('budweiserApp').controller 'TeacherCourseDetailCtrl', ($scope,$state,Restangular,Auth, $http,$upload,$location) ->
  $scope.message = 'Hello'
  $scope.course = null
  $scope.keypoints = []

  Restangular.one('courses',$state.params.id).get()
  .then (course)->
    $scope.course = course
    $scope.course.all('lectures').getList()
    .then (lectures)->
      $scope.course.$lectures = lectures
  , (error)->
    console.log error

  $scope.createKeypoint = (keypoint)->
    $scope.keypoints.push({_id:'new',name:keypoint})

  $scope.keypoints = [{
    _id:'1234'
    name:'牛顿第一定律'
    },{
    _id:'1234'
    name:'牛顿第二定律'
    },{
    _id:'1234'
    name:'牛顿第三定律'
    },{
    _id:'1234'
    name:'万有引力'
    },{
    _id:'1234'
    name:'声音的发生'
    },{
    _id:'1234'
    name:'声音的传播'
    },{
    _id:'1234'
    name:'光源'
    },{
    _id:'1234'
    name:'光的直线传播'
    }]
