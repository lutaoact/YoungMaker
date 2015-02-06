'use strict'

angular.module('mauiApp')

.config ($stateProvider) ->
  $stateProvider

  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'

  .state 'forgot',
    url: '/forgot'
    templateUrl: 'app/main/forgot/forgot.html'
    controller: 'ForgotCtrl'

  .state 'reset',
    url: '/reset?email&token'
    templateUrl: 'app/main/reset/reset.html'
    controller: 'ResetCtrl'

.factory 'Page', ($document) ->
  # return
  setTitle: (newTitle) ->
    $document[0].title = newTitle
