'use strict'

angular.module('mauiApp').directive 'userTile', ->
  templateUrl: 'app/user/userTile/userTile.html'
  restrict: 'EA'
  replace: true
  scope:
    user: '='
    me: '='

  controller: (
    $scope
    Restangular
  )->

    angular.extend $scope,
      nFollowers: 118
      nFollowing: 252


