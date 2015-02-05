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

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'groupDetail.articleList',
        page: $scope.pageConf.currentPage
        keyword: $scope.viewState?.keyword

    search: ()->
      sortObj = {}
      sortObj[$scope.pageConf.sort or 'postsCount'] = -1
      sortObj.created = -1
      Restangular.all('articles').getList
        group      : $state.params.groupId
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.viewState?.keyword
      .then (articles)->
        $scope.groupArticles = articles

  $scope.search()
