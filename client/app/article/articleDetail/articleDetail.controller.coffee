angular.module('mauiApp')

.controller 'ArticleDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    article: null

  Restangular.one('articles', $state.params.articleId)
  .get()
  .then (article) ->
    $scope.article = article
    if article.group
      Restangular.one('groups',article.group._id).get()
      .then (group)->
        $scope.group = group

