'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'xqsh',
    url: '/xqsh'
    templateUrl: 'app/xqsh/xqsh.html'
    controller: 'XqshCtrl'
