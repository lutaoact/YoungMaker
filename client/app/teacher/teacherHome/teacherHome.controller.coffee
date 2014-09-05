'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  $scope
  $state
  Restangular
  SockJSClient
) ->

  angular.extend $scope,
    courses:  Restangular.all('courses').getList().$object

    testSockJs: () ->
      SockJSClient.send 'hello world'