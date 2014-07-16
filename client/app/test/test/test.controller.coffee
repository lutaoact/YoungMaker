'use strict'

angular.module('budweiserApp').controller 'TestCtrl', ($scope, $http, User, $cookieStore) ->
  $scope.token = 'empty'
  $scope.login = (email, password)->
    $http.post('/auth/local',
      email: email
      password: password
    ).success((data) ->
      $cookieStore.put 'token', data.token
      $scope.token = data.token
      currentUser = User.get()
    ).error ((err) ->
      console.log err
    )
  $scope.logout = ()->
    $cookieStore.remove 'token'
    $scope.token = 'empty'
  $scope.request = {
    method:'GET'
  }
  $scope.response = {}

  $scope.send = ()->
    console.log $scope.request
    if not $scope.request.url
      $scope.response = 'url required'
      return
    if $scope.request.data
      try
        angular.fromJson($scope.request.data)
      catch error
        $scope.response = error
        return
    $http(
      url:$scope.request.url
      method:$scope.request.method
      data:$scope.request.data
      ).success (data)->
        $scope.response = data
      .error (err)->
        $scope.response = err
