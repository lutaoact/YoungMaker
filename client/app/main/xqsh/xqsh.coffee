'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'xqsh',
    url: '/xqsh'
    templateUrl: 'app/main/xqsh/xqsh.html'
    controller: 'XqshCtrl'
