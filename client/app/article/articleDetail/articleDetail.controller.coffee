angular.module('mauiApp')

.controller 'ArticleDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    article: null
    group: null

  Restangular
    .one('articles', $state.params.articleId)
    .get(viewer: true)
    .then (article) ->
      if !article
        $state.go '404', url : $state.href($state.current, $state.params),
          location:'replace'
        return
      $scope.article = article
      if article?.group?._id
        Restangular
          .one('groups', article.group._id)
          .get()
          .then (group) ->
            $scope.group = group
