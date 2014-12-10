'use strict'

angular.module 'mauiTestApp'

.controller 'TestCtrl', (
  Auth
  $http
  $scope
  socket
  Restangular
  $cookieStore
  $localStorage
) ->

  angular.extend $scope,
    methods: [
      'GET'
      'POST'
      'PUT'
      'PATCH'
      'DELETE'
    ]
    $storage: $localStorage
    response: {}
    token: 'empty'
    aceOptions:
      mode: 'json'

    toggleHandler: ->
      if $scope.hasHandler()
        socket.resetHandler()
      else
        socket.setHandler $scope.$storage.socketType, (data) ->
          $scope.response = data

    hasHandler: ->
      socket.hasHandler $scope.$storage.socketType

    hasOpen: ->
      socket.hasOpen()

    toggleSocket: ->
      if $scope.hasOpen()
        socket.close()
      else
        Auth.getCurrentUser().$promise?.then socket.setup

    send: (method) ->
      $scope.methods.isOpen = false
      $scope.$storage.request.method = method if method
      request = $scope.$storage.request

      console.log 'Send Request:', request

      $scope.$storage.requests = {} if !$scope.$storage.requests
      $scope.$storage.requests[request.url] = angular.copy request

      $scope.response = {}
      request.url = '/' + request.url if request?.url?.indexOf('/') != 0 && request?.url?.indexOf('http') != 0
      $http(request)
      .success (data)->
        $scope.response = data if !_.isString(data)
        console.log 'Response:', data
      .error (err)->
        $scope.response = err

    removeRequest: ->
      url = $scope.$storage.request.url
      delete $scope.$storage.requests[url]
      $scope.setRequest('')
      $scope.apiInputFocus = true

    setRequest: (url = '') ->
      $scope.$storage.request =
        url: url
        method: 'GET'

    getRequests: -> _.values $scope.$storage.requests

  $scope.setRequest('') if !$scope.$storage.request

  Auth.getCurrentUser().$promise?.then (me)->
    console.log 'me', me
