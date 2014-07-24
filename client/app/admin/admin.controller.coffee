'use strict'

angular.module('budweiserApp').controller 'AdminCtrl', ($scope, $http, Auth, User,$location) ->
  if not Auth.getCurrentUser().orgId
    $location.url('/admin/organization')

