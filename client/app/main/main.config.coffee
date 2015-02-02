'use strict'

angular.module('mauiApp')
  .config ($stateProvider) ->
    $stateProvider
    .state('main',
      url: '/'
      templateUrl: 'app/main/main.html'
      controller: 'MainCtrl'
    )

.factory 'Page', ($document) ->
  # return
  setTitle: (newTitle) ->
    $document[0].title = newTitle
