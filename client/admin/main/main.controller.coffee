'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state('main',
    url: '/',
    templateUrl: 'admin/main/main.html'
    controller: 'MainCtrl'
  )

.controller 'MainCtrl', ($scope, Restangular) ->

  Restangular.all('courses').getList()
  .then (courses)->
    $scope.courses = courses

  angular.extend $scope,
    courses: undefined



