angular.module('mauiApp')

.controller 'ArticleCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  articleAPI = Restangular.one('articles', $state.params.articleId)

  angular.extend $scope,
    me: Auth.getCurrentUser()
    article: null

    likeClick: (article) ->
      articleAPI.customPOST(null, 'like')
      .then (article) ->
        angular.extend $scope.article, article

  articleAPI.get().then (article) ->
    $scope.article = article
