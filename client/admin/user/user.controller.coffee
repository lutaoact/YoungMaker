'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state 'user',
    url: '/user'
    templateUrl: 'admin/user/user.html'
    controller: 'UserCtrl'
    authenticate: true

.controller 'UserCtrl', ($scope, Restangular, notify) ->

  Restangular.all('users').getList()
  .then (users)->
    $scope.users = users

  angular.extend $scope,

    toggleBlocked: (entity)->
      entity.patch
        blocked: if entity.blocked then null else new Date()
      .then (data)->
        angular.extend entity, data









