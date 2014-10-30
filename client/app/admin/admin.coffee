'use strict'

angular.module('mauiApp').config ($stateProvider) ->

  $stateProvider.state 'admin',
    url: '/a'
    templateUrl: 'app/admin/admin.html'
    controller: 'AdminCtrl'
    abstract: true
    authenticate: true
