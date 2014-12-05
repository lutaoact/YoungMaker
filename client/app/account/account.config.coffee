'use strict'

angular.module('mauiApp')

.config (
  $stateProvider
  $urlRouterProvider
) ->

  $urlRouterProvider.when('/settings','/settings/profile')

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

  .state 'settings',
    abstract: true
    url: '/settings'
    templateUrl: 'app/account/settings/settings.html'
    controller: 'SettingsCtrl'
    authenticate:true

  .state 'settings.profile',
    url: '/profile',
    templateUrl: 'app/account/profile/profile.html'
    controller: 'ProfileCtrl'
    authenticate:true
