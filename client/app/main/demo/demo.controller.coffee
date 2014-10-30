'use scrict'

angular.module('mauiApp').controller 'DemoCtrl', (
  Msg
  Auth
  $scope
  $state
  $location
  Restangular
) ->

  console.debug 'get demo user token...'

  angular.extend $scope,

    demoLoading: false

    demoUser: null

    loginDemoUser: ->
      $scope.demoLoading = true
      Auth.setToken($scope.demoUser.token)
      Auth.getCurrentUser().$promise.then (me) ->
        $scope.demoLoading = true
        $scope.$emit 'loginSuccess', me

  Restangular.all('demo').customGET('user')
  .then (demoUser) ->
    $scope.demoUser = demoUser
    $scope.loginDemoUser()
