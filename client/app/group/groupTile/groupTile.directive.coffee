'use strict'

angular.module('mauiApp').directive 'groupTile', ()->
  templateUrl: 'app/group/groupTile/groupTile.html'
  restrict: 'E'
  replace: true
  scope:
    group: '='
    me: '='

  controller: ($scope, $state, $timeout)->

    angular.extend $scope,
      gotoGroupDetail: ->
        $state.go 'groupDetail.articleList', groupId: $scope.group._id

      threshold: (value)->
        if value < 140 and $scope.smLogo isnt true
          $timeout ->
            $scope.smLogo = true
        else if value >= 140 and $scope.smLogo isnt false
          $timeout ->
            $scope.smLogo = false



