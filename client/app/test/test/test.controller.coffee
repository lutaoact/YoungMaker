'use strict'

angular.module('budweiserApp').controller 'TestCtrl', (
  User
  $http
  $scope
  $upload
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

    send: (method) ->
      $scope.methods.isOpen = false
      $scope.$storage.request.method = method if method
      request = $scope.$storage.request
      if !request.url
        $scope.response = 'url required'
        return
      if request.data
        try
          angular.fromJson(request.data)
        catch error
          $scope.response = error
          return

      console.debug 'Send Request:', request

      $scope.$storage.requests = {} if !$scope.$storage.requests
      $scope.$storage.requests[request.url] = angular.copy request

      $http(request)
      .success (data)->
        $scope.response = data
        console.debug 'Response:', data
      .error (err)->
        $scope.response = 'error'

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
