angular.module('mauiApp')

.controller 'ArticleCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  articleAPI = Restangular.one('articles', $state.params.articleId)

  angular.extend $scope,
    me: Auth.getCurrentUser
    article: null
    const: Const

    likeClick: (article) ->
      articleAPI.customPOST(null, 'like')
      .then (article) ->
        $scope.article.likeUsers = article.likeUsers

  articleAPI.get().then (article) ->
    $scope.article = article
