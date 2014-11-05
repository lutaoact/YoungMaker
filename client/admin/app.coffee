'use strict'

angular.module 'mauidmin', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ui.router'
  'ui.bootstrap'
  'restangular'
  'cgNotify'
]

.constant 'configs',
  baseUrl: ''

.config ($stateProvider, $urlRouterProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/')
  $httpProvider.interceptors.push 'errorInterceptor'
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'urlInterceptor'
  $httpProvider.interceptors.push 'patchInterceptor'
  $httpProvider.interceptors.push 'loadingInterceptor'

.config ($compileProvider) ->
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|blob):|data:image\//)

.config (RestangularProvider) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl('api')
  RestangularProvider.setRestangularFields(id: '_id')

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

.factory 'errorInterceptor', ($rootScope, $q) ->
  # notify errors
  responseError: (response) ->
    $rootScope.$broadcast 'network.error', response
    $q.reject response

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
      loginRedirector.set($location.url())
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

.run (
  $modal
  notify
  $state
  webview
  indexUser
  $location
  $rootScope
  loginRedirector
) ->

  $rootScope.webview = webview

  #set the default configuration options for angular-notify
  notify.config
    startTop: 30
    duration: 4000

  checkInitState = (toState) ->
    checkInitState = null
    if !toState.authenticate
      Auth.getCurrentUser().$promise?.then (me) ->
        event.preventDefault()
        $state.go(me.role+'.home')

  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    loginRedirector.set($state.href(toState, toParams)) if toState.authenticate and !Auth.isLoggedIn() and !indexUser?
    checkInitState?(toState)

  # fix bug, the view does not scroll to top when changing view.
  $rootScope.$on '$stateChangeSuccess', ->
    $("html, body").animate({ scrollTop: 0 }, 100)

  setupUser = (user, goHome = false) ->
    Msg.init()
    socketHandler.init(user)
    if !loginRedirector.apply()
      $state.go(user.role+'.home')  if goHome

  # setup data & config for logged user
  $rootScope.$on 'loginSuccess', (event, user) ->
    setupUser(user, true)

  # Reload Auth
  Auth.getCurrentUser().$promise?.then setupUser
