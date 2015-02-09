'use strict'

angular.module('maui.components').directive 'voteBox', ->
  templateUrl: 'components/directives/voteBox/voteBox.html'
  restrict: 'E'
  replace: true
  scope:
    me: '='
    entity: '='

  controller: ($scope, notify)->
    angular.extend $scope,

      stopPropagation: ($event)->
        $event.stopPropagation()

      toggleVote: ()->
        $scope.entity.one('like').post()
        .then (res)->
          $scope.entity.likeUsers = res.likeUsers

