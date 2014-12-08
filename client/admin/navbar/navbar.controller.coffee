'use strict'

angular.module 'mauidmin'

.controller 'NavbarCtrl', ($scope, $location, notify) ->
  $scope.menu = [
      title: 'Home'
      link: 'main'
    ,
      title: 'Login'
      link: 'login'
  ]
  $scope.isCollapsed = true

  $scope.errors = []

  $scope.removeError = (error)->
    $scope.errors.splice $scope.errors.indexOf(error), 1

  $scope.clearErrors = ()->
    $scope.errors.length = 0;

  $scope.isActive = (route) ->
    route is $location.path()

  $scope.$on 'network.error', (event, data)->
    console.log data
    $scope.errors.push data
    notify
      message: data
      classes:'alert-danger'

