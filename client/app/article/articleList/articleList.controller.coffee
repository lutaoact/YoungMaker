angular.module('mauiApp')

.controller 'ArticleListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->
  angular.extend $scope,
    articles: []
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 1
      sort         : $state.params.sort

    viewState:
      keyword: $state.params.keyword ? ''

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'articleList',
        page: $scope.pageConf.currentPage
        sort: $scope.pageConf.sort
        keyword: $scope.viewState?.keyword

    search: ()->
      sortObj = {}
      if $scope.pageConf.sort is 'heat'
#        sortObj.heat = -1
        sortObj.viewersNum = -1
        sortObj.commentsNum = -1
        sortObj.created = -1
      else
        sortObj.created = -1

      Restangular.all('articles').getList
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.viewState?.keyword
        sort       : JSON.stringify sortObj
      .then (articles)->
        $scope.articles = articles

  $scope.search()
