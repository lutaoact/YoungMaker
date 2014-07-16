'use strict'

angular.module('budweiserApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.bootstrap',
  'btford.socket-io',
  'ui.router',
  'ngStorage'
])
  .config (($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
    $urlRouterProvider
    .otherwise('/')
    $locationProvider.html5Mode true
    $httpProvider.interceptors.push 'authInterceptor'
  )
  .factory('authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
    # Add authorization token to headers
    request: (config) ->
      config.headers = config.headers or {}
      config.headers.Authorization = 'Bearer ' + $cookieStore.get('token')  if $cookieStore.get('token')
      config

    # Intercept 401s and redirect you to login
    responseError: (response) ->
      if response.status is 401
        $location.url('/login?r=' + $location.url())
        # remove any stale tokens
        $cookieStore.remove 'token'
        $q.reject response
      else
        $q.reject response
  )
  .run (($rootScope, $location, Auth) ->
    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$stateChangeStart', (event, next) ->
      ###
      next.authenticate can be configed in route
      .state('admin',
      url: '/admin',
      templateUrl: 'app/admin/admin.html'
      controller: 'AdminCtrl'
      authenticate:true
      )
      ###
      $location.url('/login?r=' + next.url) if next.authenticate and not Auth.isLoggedIn()
  )
