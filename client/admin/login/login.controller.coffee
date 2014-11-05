'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state('login',
    url: '/login',
    templateUrl: 'admin/login/login.html'
    controller: 'LoginCtrl'
  )

.controller 'LoginCtrl', ($scope) ->
  $scope.message = 'hello'
