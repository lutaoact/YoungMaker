'use strict'

angular.module('mauiApp')

.controller 'UserActivitiesCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    activities: null
    pageConf:
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 20

    changePage: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  $scope.$emit 'updateTitle', ->
    if $scope.user
      $scope.user.name + '的最新动态'
    else
      '最新动态'

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

