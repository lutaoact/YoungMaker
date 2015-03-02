angular.module('mauiApp')

.controller 'ArticleListCtrl', (
  $scope
  $state
  $filter
  Restangular
) ->

  angular.extend $scope,
    articles: []
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 10
      sort         : $state.params.sort
      tags         : $filter('array')($state.params.tags)
      keyword      : $state.params.keyword ? ''

    removeTag: (tag) ->
      $scope.pageConf.tags = _.without($scope.pageConf.tags, tag)
      $scope.reload()

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'articleList',
        page: $scope.pageConf.currentPage
        sort: $scope.pageConf.sort
        tags: $scope.pageConf.tags
        keyword: $scope.pageConf.keyword

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
        keyword    : $scope.pageConf.keyword
        tags       : JSON.stringify $scope.pageConf.tags if _.isArray($scope.pageConf.tags)
        sort       : JSON.stringify sortObj
      .then (articles)->
        $scope.articles = articles

  $scope.search()

  $scope.$emit 'updateTitle', ->
    $scope.pageConf.tags.join('+') +
      if $scope.pageConf.sort is 'heat'
        '最热文章'
      else
        '最新文章'
