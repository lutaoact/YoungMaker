'use strict'

angular.module('budweiserApp').controller 'TeacherManagerCtrl', ($scope, $http, Auth, User,$filter, $timeout) ->
  $http.get('/api/users').success (users) ->
    ###$scope.users = $filter('filter')(users, (user)->
        user._id isnt Auth.getCurrentUser()._id
      )###
    # more simplified
    $scope.users = $filter('filter')(users,{_id:"!" + Auth.getCurrentUser()._id})

  $scope.onFileSelect = (file)->
    console.log 'in'
    $scope.isExcelProcessing = true
    $timeout ()->
      for i in [0..10]
        do (i)->
          $scope.users.push
            name:"xxx"+i
            email:"xxx" + i + "@xxx.com"
            role:"teacher"
            _id: i + "xxx"
      console.log 'finished'
      $scope.isExcelProcessing = false
    , 3000

  $scope.delete = (user) ->
    # Check if the user to delete is self.
    if user._id is Auth.getCurrentUser()._id
      return
    User.remove id: user._id
    angular.forEach $scope.users, (u, i) ->
      $scope.users.splice i, 1  if u is user

  $scope.isExcelProcessing = false



