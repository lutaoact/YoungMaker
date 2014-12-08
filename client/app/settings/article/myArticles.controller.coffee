angular.module('mauiApp')

.controller 'MyArticlesCtrl', (
  Auth
  $scope
  Restangular
) ->

  reloadArticles = ->
    Restangular.all('articles').getList(author: Auth.getCurrentUser()._id)
    .then (articles) ->
      $scope.articles = articles

  angular.extend $scope,
    articles: null

    removeArticle: (article) ->
      article.remove().then reloadArticles

  reloadArticles()
