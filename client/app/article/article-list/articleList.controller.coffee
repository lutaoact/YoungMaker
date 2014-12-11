angular.module('mauiApp')

.controller 'ArticleListCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  reloadArticles = ->
    Restangular.all('articles').getList()
    .then (articles) ->
      $scope.articles = articles

  angular.extend $scope,
    articles: null

    removeArticle: (article) ->
      article.remove().then reloadArticles

  reloadArticles()

  loadGroups = ->
    Restangular.all('groups').getList()
    .then (groups) ->
      $scope.groups = groups

  loadGroups()