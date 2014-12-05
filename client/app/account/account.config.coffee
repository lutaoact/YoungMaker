'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
) ->

  $stateProvider

  .state 'login',
    url: '/login'
    templateUrl: 'app/account/login/login.html'
    controller: 'LoginCtrl'

  .state 'forgot',
    url: '/forgot'
    templateUrl: 'app/account/forgot/forgot.html'
    controller: 'ForgotCtrl'
    navClasses: 'home-nav'

  .state 'signup',
    url: '/signup'
    templateUrl: 'app/account/signup/signup.html'
    controller: 'SignupCtrl'

