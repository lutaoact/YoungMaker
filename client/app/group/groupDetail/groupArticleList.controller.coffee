angular.module('mauiApp')

.controller 'GroupArticleListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->
  angular.extend $scope,
    groupArticles: []
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 3
      sort         : $state.params.sort

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'groupDetail.articleList',
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
        group      : $state.params.groupId
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.viewState?.keyword
        sort       : JSON.stringify sortObj
      .then (articles)->
        $scope.groupArticles = articles

  $scope.search()
