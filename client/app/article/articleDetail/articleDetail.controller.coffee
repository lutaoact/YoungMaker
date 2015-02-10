angular.module('mauiApp')

.controller 'ArticleDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    article: null

  Restangular
    .one('articles', $state.params.articleId)
    .get()
    .then (article) ->
      $scope.article = article
