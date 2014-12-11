angular.module('mauiApp')

.controller 'ArticleListCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    articles: null

  Restangular.all('groups').getList()
  .then (groups) ->
    $scope.groups = groups

  Restangular.all('articles').getList(author: me._id)
  .then (articles) ->
    $scope.articles = articles
