'use strict'

angular.module 'budweiserApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.bootstrap',
  'btford.socket-io',
  'ui.router',
  'ngStorage',
  'ui.select2',
  'angularFileUpload',
  'restangular',
  'cgNotify',
  'ngRepeatReorder',
  'com.2fdevs.videogular',
  'com.2fdevs.videogular.plugins.controls',
  'com.2fdevs.videogular.plugins.overlayplay',
  'com.2fdevs.videogular.plugins.buffering',
  'com.2fdevs.videogular.plugins.poster',
  'highcharts-ng',
  'ngAnimate',
  'ui.ace',
  'jsonFormatter'
]

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/')
  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'patchInterceptor'
  $httpProvider.interceptors.push 'loadingInterceptor'

.config (RestangularProvider) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl('api')
  RestangularProvider.setRestangularFields(id: "_id")

# Override patch to put
.factory 'patchInterceptor', ($location) ->
  request: (config) ->
    if config.method is 'PATCH'
      config.method = 'PUT'
    config

.factory 'LoginRedirector', ($location) ->

  redirectKey = 'r'
  loginPath = '/login' #/login?r=xxx

  getRedirectUrl = ->
    redirect = $location.search()[redirectKey]
    if !redirect? then return undefined
    encodeURIComponent redirect

  set: (newRedirect) ->
    if getRedirectUrl()? || newRedirect is loginPath then return
    $location.url "#{loginPath}?#{redirectKey}=#{newRedirect}"

  apply: ->
    if !getRedirectUrl()? then return false
    $location.url getRedirectUrl()
    $location.replace()
    true


.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location, LoginRedirector) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get('token')  if $cookieStore.get('token')
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      LoginRedirector.set($location.url())
      # remove any stale tokens
      $cookieStore.remove 'token'
      $q.reject response
    else
      $q.reject response

.factory 'loadingInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # remain request numbers
  numLoadings = 0

  request: (config) ->
    numLoadings++
    $rootScope.$loading = true
    config

  response: (response)->
    if --numLoadings is 0
      # Hide loader
      $rootScope.$loading = false
    response or $q.when(response)

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if --numLoadings is 0
      $rootScope.$loading = false
    $q.reject response

.run ($rootScope, $location, Auth, LoginRedirector, $state) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    console.debug toState, Auth.isLoggedIn()
    LoginRedirector.set($state.href(toState, toParams)) if toState.authenticate and !Auth.isLoggedIn()

  # Reload Auth
  Auth.getCurrentUser().$promise?.then LoginRedirector.apply

