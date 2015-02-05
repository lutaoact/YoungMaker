'use strict'

angular.module('mauiApp')

.controller 'UserArticlesCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    articles: null
    pageConf:
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 10

    changePage: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage

  Restangular
    .all('articles')
    .getList(
      author: $state.params.userId
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (articles) ->
      $scope.articles = articles
