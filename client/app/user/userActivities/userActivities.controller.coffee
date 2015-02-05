'use strict'

angular.module('mauiApp')

.controller 'UserActivitiesCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    activities: []
    pageConf:
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 10

    changePage: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  $scope.$watch 'me', ->
    Restangular
      .all('activities')
      .getList(
        userId: $state.params.userId
        from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit: $scope.pageConf.itemsPerPage
      )
      .then (activities) ->
        $scope.activities = activities

