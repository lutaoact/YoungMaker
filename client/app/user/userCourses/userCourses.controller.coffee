'use strict'

angular.module('mauiApp')

.controller 'UserCoursesCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    courses: []
    pageConf:
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 10

    changePage: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  Restangular
    .all('courses')
    .getList(
      author: $state.params.userId
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (courses) ->
      $scope.courses = courses
