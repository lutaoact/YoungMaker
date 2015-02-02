'use strict'

angular.module('mauiApp').directive 'groupTile', ()->
  templateUrl: 'app/group/groupTile/groupTile.html'
  restrict: 'E'
  replace: true
  scope:
    group: '='

#  controller: ($scope, $modal, $http, messageModal)->
#    angular.extend $scope,
#
#      stopPropagation: ($event)->
#        $event.stopPropagation()
