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

  $scope.isActive = (route) ->
    route is $location.path()

  $scope.$on 'network.error', (event, data)->
    console.log data
    notify
      message: data
      classes:'alert-danger'

