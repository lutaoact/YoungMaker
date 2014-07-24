'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'word',
    url: '/word'
    templateUrl: 'app/word/word.html'
    controller: 'WordCtrl'
