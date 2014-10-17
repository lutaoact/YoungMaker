'use scrict'

angular.module('budweiserApp').controller 'DemoCtrl', (
  Msg
  Auth
  $scope
  $location
  Restangular
  socketHandler
  loginRedirector
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
        socketHandler.init(me)
        Msg.init()
        if !loginRedirector.apply()
          if me.role is 'admin'
            $location.url('/a')
          else if me.role is 'teacher'
            $location.url('/t')
          else if me.role is 'student'
            $location.url('/s')
          $location.replace()

  Restangular.all('demo').customGET('user')
  .then (demoUser) ->
    $scope.demoUser = demoUser
    $scope.loginDemoUser()
