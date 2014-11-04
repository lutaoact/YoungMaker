'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state('main',
    url: '/',
    templateUrl: 'admin/main/main.html'
    controller: 'MainCtrl'
  )

.controller 'MainCtrl', ($scope) ->
  $scope.message = 'hello'
