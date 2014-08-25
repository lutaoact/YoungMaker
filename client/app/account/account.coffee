'use strict'

angular.module('budweiserApp')
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.when('/settings','/settings/profile')
    $stateProvider
    .state('login',
      url: '/login',
      templateUrl: 'app/account/login/login.html'
      controller: 'LoginCtrl'
    )
    .state('signup',
      url: '/signup',
      templateUrl: 'app/account/signup/signup.html'
      controller: 'SignupCtrl'
    )
    .state('settings',
      abstract: true
      url: '/settings'
      templateUrl: 'app/account/settings/settings.html'
      controller: 'SettingsCtrl'
      authenticate:true
    )
    .state('settings.profile',
      url: '/profile',
      templateUrl: 'app/account/profile/profile.html'
      controller: 'ProfileCtrl'
      authenticate:true
    )
    .state('settings.security',
      url: '/security',
      templateUrl: 'app/account/security/security.html'
      controller: 'SecurityCtrl'
      authenticate:true
    )
    .state('settings.billing',
      url: '/billing',
      templateUrl: 'app/account/billing/billing.html'
      controller: 'BillingCtrl'
      authenticate:true
    )
