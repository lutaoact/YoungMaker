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
      keyword: $state.params.keyword ? undefined
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 10

    reload: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage
        keyword: $scope.pageConf.keyword

  Restangular
    .all('articles')
    .getList(
      author: $state.params.userId
      keyword: $scope.pageConf.keyword
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (articles) ->
      $scope.articles = articles
