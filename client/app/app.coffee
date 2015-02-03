'use strict'

angular.module 'mauiApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngAnimate'
  'ngStorage'
  'ui.router'
  'ui.select'
  'cgNotify'
  'duScroll'
  'restangular'
  'angularFileUpload'
  'monospaced.elastic'
  'angular-sortable-view'
  'maui.components'
]

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/')
  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'urlInterceptor'
  $httpProvider.interceptors.push 'patchInterceptor'
  $httpProvider.interceptors.push 'loadingInterceptor'

.config ($compileProvider) ->
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|blob):|data:image\//)

.config (RestangularProvider) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl('api')
  RestangularProvider.setRestangularFields(id: "_id")
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is "getList" and data.results
      data.results.$count = data.count
      data.results
    else
      data

.factory 'urlInterceptor', ($rootScope, $q, $cookieStore, $location,configs) ->
  # Add authorization token to headers
  request: (config) ->
    config.url = configs.baseUrl + config.url if /^(|\/)(api|auth)/.test config.url
    config

# Override patch to put
.factory 'patchInterceptor', ($location) ->
  request: (config) ->
    if config.method is 'PATCH'
      config.method = 'PUT'
    config

.factory 'loginRedirector', ($location) ->

  redirectKey = 'r'
  loginPath = '/'

  getRedirectUrl = ->
    redirect = $location.search()[redirectKey]
    if !redirect? then return undefined
    redirect

  set: (newRedirect) ->
    if getRedirectUrl()? || newRedirect is loginPath then return
    redirect = encodeURIComponent newRedirect
    $location.url "#{loginPath}?#{redirectKey}=#{redirect}"

  apply: ->
    if !getRedirectUrl()? then return false
    $location.url getRedirectUrl()
    $location.replace()
    true

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location, loginRedirector) ->
  # Add authorization token to headers
  request: (config) ->
    # When not withCredentials, should not carry Authorization header either
    if config.withCredentials is false
      return config
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get('token')  if $cookieStore.get('token')
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      # remove any stale tokens
      $cookieStore.remove 'token'
      $q.reject response
    else
      $q.reject response

.factory 'loadingInterceptor', ($rootScope, $q) ->
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

.run (
  Auth
  $modal
  notify
  $state
  configs
  initUser
  $timeout
  $rootScope
  loginRedirector
) ->

  #set the default configuration options for angular-notify
  notify.config
    startTop: 30
    duration: 4000

  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    if toState.authenticate and !Auth.isLoggedIn() and !initUser?
      loginRedirector.set($state.href(toState, toParams))
      $modal.open
        templateUrl: 'app/login/loginModal.html'
        controller: 'loginModalCtrl'
        windowClass: 'login-window-modal'
        size: 'md'

  # fix bug, the view does not scroll to top when changing view.
  $rootScope.$on '$stateChangeSuccess', ->
    $("html, body").animate({ scrollTop: 0 }, 100)

  checkState = (state, params) ->
    if state.authenticate
      loginRedirector.set $state.href(state, params)

  # Setup data & config for logged user
  $rootScope.const = Const
  $rootScope.$state = $state
  $rootScope.configs = configs
  $rootScope.$watch Auth.getCurrentUser, (newUser) ->
    $rootScope.me = newUser
    if Auth.isLoggedIn()
      loginRedirector.apply()
    else
      checkState($state.current, $state.params)
  Auth.refreshCurrentUser() if initUser?
