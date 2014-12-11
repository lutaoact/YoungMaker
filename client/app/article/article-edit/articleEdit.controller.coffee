angular.module('mauiApp')

.controller 'ArticleEditCtrl', (
  focus
  $scope
  $state
  notify
  Restangular
) ->

  angular.extend $scope,
    article: {}

    saveArticle: (form) ->
      if !form.$valid then return
      if _.isEmpty $scope.article.content
        focus 'articleContent'
        return
      console.log $scope.article
      onSave = (article) ->
        $scope.onSave?(article:article)
        notify
          message: '文章已保存'
          classes: 'alert-success'
      onError = (error) ->
        $scope.onError?(error:error)
        notify
          message: '保存文章出错啦：' + error
          classes: 'alert-danger'
      if $scope.article.save?
        $scope.article.save()
        .then onSave
        .catch onError
      else
        Restangular.all('articles').post($scope.article)
        .then onSave
        .catch onError

  Restangular.one('articles', $state.params.articleId).get()
  .then (article) ->
    $scope.article = article
    focus 'articleTitle'
  .catch (error) ->
    notify
      message: '文章不存在或者已经删除：' + error
      classes: 'alert-danger'
