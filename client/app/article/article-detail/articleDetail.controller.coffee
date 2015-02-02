angular.module('mauiApp')

.controller 'ArticleDetailCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  articleAPI = Restangular.one('articles', $state.params.articleId)

  angular.extend $scope,
    article: null
    const: Const

    likeClick: (article) ->
      articleAPI.customPOST(null, 'like')
      .then (article) ->
        $scope.article.likeUsers = article.likeUsers

  articleAPI.get().then (article) ->
    $scope.article = article
