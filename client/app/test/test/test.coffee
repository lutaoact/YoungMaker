'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'test',
    url: '/test'
    templateUrl: 'app/test/test/test.html'
    controller: 'TestCtrl'
    authenticate: true
