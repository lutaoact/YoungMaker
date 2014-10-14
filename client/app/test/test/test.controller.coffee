'use strict'

angular.module('budweiserApp').controller 'TestCtrl', (
  Auth
  $http
  $scope
  socket
  $upload
  Restangular
  $cookieStore
  $localStorage
  $tools
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

      console.debug 'Send Request:', request

      $scope.$storage.requests = {} if !$scope.$storage.requests
      $scope.$storage.requests[request.url] = angular.copy request

      $scope.response = {}
      $http(request)
      .success (data)->
        $scope.response = data if !_.isString(data)
        console.debug 'Response:', data
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

    genColor: (input)->

      doGenColor = (str)->
        str = utf8.encode str
        r = 256 - str.substr(-1,1).charCodeAt()
        g = 256 - str.substr(-4,1).charCodeAt()
        b = 256 - str.substr(-7,1).charCodeAt()
        'rgb(' + [r,g,b].join() + ')'

      $scope.nameColor = doGenColor(input)

  $scope.setRequest('') if !$scope.$storage.request
