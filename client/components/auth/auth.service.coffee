'use strict'

angular.module('maui.components')

.factory 'Auth', (
  $q
  $http
  $rootScope
  Restangular
  ipCookie
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
      deferred.resolve @refreshCurrentUser()
    ).bind(@)
    .error ((err) ->
      @logout()
      deferred.reject err
    ).bind(@)
    deferred.promise

  ###
  Delete access token and user info
  ###
  logout: ->
    ipCookie.remove 'token'
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
  Checks if the user role meets the minimum requirements of the route

  @return {Boolean}
  ###
  hasRole: (roleRequired, role) ->
    userRoles = [
      'user'      # 允许登录后的用户 abstract
      'editor'    # 允许编辑别人的文章
      'admin'     # 允许管理员或以上
      'superuser' # 允许超级用户
    ]
    userRoles.indexOf(currentUser.role ? role) >= userRoles.indexOf(roleRequired)

  userRole : ->
    currentUser.role

  ###
  Check if a user is logged in

  @return {Boolean}
  ###
  isLoggedIn: -> currentUser._id?

  ###
  Get auth token
  ###
  getToken: ->
    ipCookie 'token'
