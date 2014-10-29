'use strict'

angular.module('budweiserApp').config (
  $stateProvider
  $urlRouterProvider
) ->

  $urlRouterProvider.when("/a", "/a/organization")

  $stateProvider.state 'admin.home',
    url: '/organization'
    templateUrl: 'app/admin/organization/organization.html'
    controller: 'OrganizationCtrl'
    authenticate: true
