'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
) ->

  $stateProvider

  .state 'user',
    url: '/users/:userId',
    templateUrl: 'app/user/user.html'
    controller: 'UserCtrl'
