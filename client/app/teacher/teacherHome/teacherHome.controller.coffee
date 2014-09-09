'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    courses:  Restangular.all('courses').getList().$object
