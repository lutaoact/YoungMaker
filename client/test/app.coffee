'use strict'

angular.module 'mauiTestApp', [
  'maui.components'
  'ngCookies'
  'ngResource'
  'ngStorage'
  'ui.bootstrap'
  'restangular'
]

.config ($httpProvider) ->
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'urlInterceptor'
  $httpProvider.interceptors.push 'patchInterceptor'
  $httpProvider.interceptors.push 'loadingInterceptor'

.config ($compileProvider) ->
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|blob):|data:image\//)

.config (RestangularProvider) ->
  # Add a response intereceptor
  RestangularProvider.setBaseUrl('api')
  RestangularProvider.setRestangularFields(id: '_id')

.factory 'urlInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.url = config.url if /^(|\/)(api|auth)/.test config.url
    config

# Override patch to put
.factory 'patchInterceptor', ->
  request: (config) ->
    config.method = 'PUT' if config.method is 'PATCH'
    config

.factory 'authInterceptor', ($rootScope, $q, $cookieStore) ->
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

