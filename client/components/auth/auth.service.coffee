'use strict'

angular.module('budweiserApp').factory 'Auth', (
  $q
  User
  $http
  $location
  $rootScope
  $cookieStore
) ->

  currentUser =
    if $cookieStore.get('token') then User.get() else {}

  ###
  Authenticate user and save token

  @param  {Object}   user     - login info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  login: (user, callback) ->
    cb = callback or angular.noop
    deferred = $q.defer()
    $http.post('/auth/local', user).success ((data) ->
      @setToken(data.token)
      deferred.resolve currentUser
      cb()
    ).bind(@)
    .error ((err) ->
      @logout()
      deferred.reject err
      cb err
    ).bind(@)
    deferred.promise

  ###
  Save token and reset User

  @param {String} token
  ###
  setToken: (token) ->
    $cookieStore.put 'token', token
    currentUser = User.get()


  ###
  Delete access token and user info

  @param  {Function}
  ###
  logout: ->
    $cookieStore.remove 'token'
    currentUser = {}
    return


  ###
  Create a new user

  @param  {Object}   user     - user info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  createUser: (user, callback) ->
    cb = callback or angular.noop
    User.save(user, (data) ->
      $cookieStore.put 'token', data.token
      currentUser = User.get()
      cb user
    , ((err) ->
      @logout()
      cb err
    ).bind(this)).$promise


  ###
  Change password

  @param  {String}   oldPassword
  @param  {String}   newPassword
  @param  {Function} callback    - optional
  @return {Promise}
  ###
  changePassword: (oldPassword, newPassword, callback) ->
    cb = callback or angular.noop
    User.changePassword(
      id: currentUser._id
    ,
      oldPassword: oldPassword
      newPassword: newPassword
    , (user) ->
      cb user
    , (err) ->
      cb err
    ).$promise


  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    currentUser

  ###
  Check if a user is logged in

  @return {Boolean}
  ###
  isLoggedIn: ->
    #To support pasted url navigation
    currentUser.hasOwnProperty('role')

  ###
  Check if a user is an admin

  @return {Boolean}
  ###
  isAdmin: ->
    currentUser.role is 'admin'


  ###
  Get auth token
  ###
  getToken: ->
    $cookieStore.get 'token'
