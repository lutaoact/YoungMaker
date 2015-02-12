'use strict'

angular.module('mauiApp').directive 'groupTile', ()->
  templateUrl: 'app/group/groupTile/groupTile.html'
  restrict: 'E'
  replace: true
  scope:
    group: '='
    me: '='

  controller: ($scope, Restangular, notify, $state, $modal)->

    angular.extend $scope,
      gotoGroupDetail: ->
        $state.go 'groupDetail.articleList', groupId: $scope.group._id

