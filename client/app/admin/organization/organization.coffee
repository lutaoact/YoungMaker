'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'admin.organization',
    url: '/organization'
    templateUrl: 'app/admin/organization/organization.html'
    controller: 'OrganizationCtrl'
