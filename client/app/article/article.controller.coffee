angular.module('mauiApp')

.controller 'ArticleCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    article: Restangular.one('articles', $state.params.articleId).get().$object