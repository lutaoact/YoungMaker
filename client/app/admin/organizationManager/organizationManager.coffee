'use strict'

angular.module('budweiserApp').config (
  $stateProvider
  $urlRouterProvider
) ->

  $urlRouterProvider.when("/a", "/a/organization")

  $stateProvider.state 'admin.home',
    url: '/organization'
    templateUrl: 'app/admin/organizationManager/organizationManager.html'
    controller: 'OrganizationManagerCtrl'
    authenticate: true
