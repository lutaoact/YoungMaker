'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'demo',
    url: '/demo'
    templateUrl: 'app/main/demo/demo.html'
    controller: 'DemoCtrl'
