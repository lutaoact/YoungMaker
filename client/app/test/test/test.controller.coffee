'use strict'

angular.module('budweiserApp').controller 'TestCtrl', ($scope, $http, User, $cookieStore,$localStorage) ->
  $scope.$storage = $localStorage;
  if not $scope.$storage.request
    $scope.$storage.request = {
      method:'GET'
    }
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
  $scope.response = {}

  $scope.send = ()->
    console.log $scope.$storage.request
    if not $scope.$storage.request.url
      $scope.response = 'url required'
      return
    if $scope.$storage.request.data
      try
        angular.fromJson($scope.$storage.request.data)
      catch error
        $scope.response = error
        return
    $http(
      url:$scope.$storage.request.url
      method:$scope.$storage.request.method
      data:$scope.$storage.request.data
      ).success (data)->
        $scope.response = data
      .error (err)->
        $scope.response = err
