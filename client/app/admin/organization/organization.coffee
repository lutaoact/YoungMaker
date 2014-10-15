'use strict'

angular.module('budweiserApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.when("/admin", "/admin/organization")
  $stateProvider.state 'admin.organization',
    url: '/organization'
    templateUrl: 'app/admin/organization/organization.html'
    controller: 'OrganizationCtrl'
