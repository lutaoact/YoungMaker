'use strict'

angular.module 'mauiApp', [
  'maui.components'
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngAnimate'
  'ngStorage'
  'ui.bootstrap'
  'ui.router'
  'ui.select'
  'com.2fdevs.videogular'
  'com.2fdevs.videogular.plugins.controls'
  'com.2fdevs.videogular.plugins.overlayplay'
  'com.2fdevs.videogular.plugins.buffering'
  'com.2fdevs.videogular.plugins.poster'
  'cgNotify'
  'duScroll'
  'restangular'
  'highcharts-ng'
  'angularFileUpload'
  'monospaced.elastic'
  'angular-sortable-view'
  'textAngular'
]

.constant 'configs',
  baseUrl: ''
  fpUrl: 'http://54.223.144.96:9090/'

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

.factory 'loginRedirector', ($location, $localStorage) ->

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

.service 'socketHandler', (
  socket
  $modal
  $rootScope
) ->

  init: (me) ->
    socket.setup()
    if me?
      socket.setHandler Const.MsgType.Notice, (data) ->
        $rootScope.$broadcast 'message.notice', data
    if me?.role is 'student'
      socket.setHandler Const.MsgType.Quiz, (data) ->
        $modal.open
          templateUrl: 'app/teacher/teacherTeaching/receiveQuestion.html'
          controller: 'ReceiveQuestionCtrl'
          backdrop: 'static'
          resolve:
            answer: -> data.answer
            question: -> data.question
            teacherId: -> data.teacherId

.run (
  Msg
  Auth
  Page
  $modal
  notify
  $state
  webview
  initUser
  $location
  $rootScope
  socketHandler
  loginRedirector
) ->

  $rootScope.Page = Page
  $rootScope.webview = webview

  #set the default configuration options for angular-notify
  notify.config
    startTop: 30
    duration: 4000

  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    loginRedirector.set($state.href(toState, toParams)) if toState.authenticate and !Auth.isLoggedIn() and !initUser?

  # fix bug, the view does not scroll to top when changing view.
  $rootScope.$on '$stateChangeSuccess', ->
    $("html, body").animate({ scrollTop: 0 }, 100)

  setupUser = (user, goHome = false) ->
    Msg.init()
    socketHandler.init(user)
    if !loginRedirector.apply()
      $state.go('settings.profile')  if goHome

  # setup data & config for logged user
  $rootScope.$on 'loginSuccess', (event, user) ->
    setupUser(user, true)

  # Reload Auth
  Auth.getCurrentUser().$promise?.then setupUser

