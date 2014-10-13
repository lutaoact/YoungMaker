'use strict'

angular.module('budweiserApp').controller 'MainCtrl',
(
  Msg
  $scope
  $http
  Auth
  $state
  $location
  socketHandler
  loginRedirector
  notify
  Page
) ->
  Page.setTitle '云立方学院 cloud3edu 提供教育云服务，教育的云计算时代，从云立方学院开始'
