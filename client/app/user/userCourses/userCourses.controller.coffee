'use strict'

angular.module('mauiApp')

.controller 'UserCoursesCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    courses: null
    pageConf:
      keyword: $state.params.keyword ? undefined
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 20

    reload: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage
        keyword: $scope.pageConf.keyword

  $scope.$emit 'updateTitle', ->
    if $scope.user
      $scope.user.name + '创建的所有趣课'

  Restangular
    .all('courses')
    .getList(
      author: $state.params.userId
      keyword: $scope.pageConf.keyword
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (courses) ->
      $scope.courses = courses
