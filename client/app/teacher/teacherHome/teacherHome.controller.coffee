'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', ($scope,$state,Restangular,Auth, $http,$upload,$location) ->

  angular.extend $scope,
    courses:  Restangular.all('courses').getList().$object
