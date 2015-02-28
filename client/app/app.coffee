'use strict'

((console)->
  if /localhost/.test window.location.hostname
    console.remote = console.log
    return
  methods = ['log', 'error', 'remote']
  methods.map (method) ->
    oldFn = console[method]
    console[method] = (message)->
      if window.XMLHttpRequest
        xmlhttp = new XMLHttpRequest()
      else
        xmlhttp= new ActiveXObject("Microsoft.XMLHTTP")
      xmlhttp.open('POST',"/api/loggers",true)
      xmlhttp.setRequestHeader('Accept', '*')
      xmlhttp.setRequestHeader('Content-Type', 'application/json')
      try
        xmlhttp.send(JSON.stringify(_.values(arguments)))
      catch e
        xmlhttp.send(JSON.stringify(["error","JSON_convert",e?.toString()]))
      oldFn?.apply(console, arguments)
)(console)

((window)->
  preErrorHander = window.onerror
  window.onerror = (m, u, l)->
    preErrorHander?(m,u,l)
    console.remote 'error', 'onJSError', m, u, l
)(window)
angular.module 'mauiApp', [
  'duScroll'
  'ngAnimate'
  'ui.select'
  'maui.components'
  'monospaced.elastic'
  'angular-sortable-view'
  'ui.ace'
  'monospaced.qrcode'
]

.value('duScrollGreedy', true)

.config ($provide) ->
  $provide.decorator "$exceptionHandler", ($delegate) ->
    (exception, cause)->
      $delegate(exception, cause)
      exception.cause = cause
      console.remote 'error','onAngularError', exception

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/')
  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'urlInterceptor'
  $httpProvider.interceptors.push 'patchInterceptor'
  $httpProvider.interceptors.push 'objectIdInterceptor'
  $httpProvider.interceptors.push 'loadingInterceptor'
  $httpProvider.interceptors.push 'errorHttpInterceptor'

.config ($compileProvider) ->
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|blob):|data:image\//)

.config (RestangularProvider) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl('api')
  RestangularProvider.setRestangularFields(id: "_id")
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is 'getList' && data?.results
      count = data.count
      data = data.results
      data.$count = count
    return data

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

# Extract id when puting or posting object
.factory 'objectIdInterceptor', ($location) ->
  request: (config) ->
    if config.data
      for own key, value of config.data
        if key.endsWith('Id') and value instanceof Object
          config.data[key] = value._id
    config

.factory 'errorHttpInterceptor', ($q) ->
  responseError: (response) ->
    if response.status isnt 401 # for privacy
      console.remote 'error', 'onHttpError', response
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
  $rootScope.Auth = Auth
  $rootScope.root = {}
  $rootScope.root.navbarVisible = true
  $rootScope.$watch Auth.getCurrentUser, (newUser) ->
    $rootScope.me = newUser
    if Auth.isLoggedIn()
      loginRedirector.apply()
    else
      checkState($state.current, $state.params)
  if initUser
    _hmt?.push(['_setCustomVar', 1, 'login', initUser._id, 2])
  else
    _hmt?.push(['_setCustomVar', 0, 'login', false, 2])
  Auth.refreshCurrentUser() if initUser?
