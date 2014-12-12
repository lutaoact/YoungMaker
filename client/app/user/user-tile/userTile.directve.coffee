'use strict'

angular.module('mauiApp').directive 'userTile', ->
  templateUrl: 'app/user/user-tile/user-tile.html'
  restrict: 'EA'
  replace: true
  scope:
    user: '='
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth)->
    angular.extend $scope,
      stopPropagation: ($event)->
        $event.stopPropagation()



