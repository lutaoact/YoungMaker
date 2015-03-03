'use strict'

angular.module 'mauiTestApp'

.controller 'TestCtrl', (
  Auth
  $http
  $scope
  Restangular
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

      $scope.$storage.requests = {} if !$scope.$storage.requests
      $scope.$storage.requests[request.url] = angular.copy request

      $scope.response = {}
      request.url = '/' + request.url if request?.url?.indexOf('/') != 0 && request?.url?.indexOf('http') != 0
      $http(request)
      .success (data)->
        $scope.response = data if !_.isString(data)
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
