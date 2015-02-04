'use strict'

angular.module('maui.components')

.factory 'Auth', (
  $q
  $http
  $rootScope
  Restangular
  $cookieStore
  $localStorage
) ->

  currentUser = {}

  ###
  Authenticate user and save token

  @param  {Object}   user - login info
  @return {Promise}
  ###
  login: (user) ->
    deferred = $q.defer()
    $http.post('/auth/local', user).success ((data) ->
      $rootScope.$emit 'loginSuccess'
      deferred.resolve @setToken(data.token)
    ).bind(@)
    .error ((err) ->
      @logout()
      deferred.reject err
    ).bind(@)
    deferred.promise

  ###
  Save token and reset User

  @param {String} token
  ###
  setToken: (token) ->
    $cookieStore.put 'token', token
    @refreshCurrentUser()

  ###
  Delete access token and user info
  ###
  logout: ->
    $cookieStore.remove 'token'
    currentUser = {}
    $rootScope.$emit 'logoutSuccess'
    return

  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    currentUser

  ###
  Refresh info on authenticated user
  ###
  refreshCurrentUser: (callback) ->
    Restangular
    .one('users', 'me')
    .get()
    .then (user) ->
      currentUser = user
      $localStorage.user = user
    .finally ->
      callback?(currentUser)

  ###
  Check if a user is logged in

  @return {Boolean}
  ###
  isLoggedIn: -> currentUser._id?

  ###
  Get auth token
  ###
  getToken: -> $cookieStore.get 'token'
