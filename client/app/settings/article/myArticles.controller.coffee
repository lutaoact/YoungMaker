angular.module('mauiApp')

.controller 'MyArticlesCtrl', (
  Auth
  $scope
  notify
  Restangular
) ->

  angular.extend $scope,
    articles: null

    removeArticle: (article) ->
      article.remove().then ->
        index = $scope.articles.indexOf article
        $scope.articles.splice index, 1
        notify
          message: '文章已经删除'
          classes: 'alert-success'

  Auth.getCurrentUser().$promise?.then (me)->
    Restangular.all('articles').getList(author: me._id)
    .then (articles) ->
      $scope.articles = articles
