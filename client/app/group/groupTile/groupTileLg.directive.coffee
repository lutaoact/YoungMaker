'use strict'

angular.module('mauiApp').directive 'groupTileLg', ()->
  templateUrl: 'app/group/groupTile/groupTileLg.html'
  restrict: 'E'
  replace: true
  scope:
    group: '='
    me: '='

  controller: ($scope, Restangular, notify, $state, $modal)->
#    angular.extend $scope,

    $scope.$watch 'group', (group)->
      if group?
        Restangular.one('groups', group._id).one('members')
        .get()
        .then (members)->
          $scope.groupMembers = members
