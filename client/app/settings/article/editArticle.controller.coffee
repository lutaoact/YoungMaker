angular.module('mauiApp')

.controller 'EditArticleCtrl', (
  Auth
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
      console.debug $scope.article
      if $scope.article.save?
        $scope.article.save()
        .then ->
          notify
            message: '文章已保存'
            classes: 'alert-success'
        .catch (error) ->
          notify
            message: '保存文章出错啦：' + error
            classes: 'alert-danger'
      else
        Restangular.all('articles').post($scope.article)
        .then ->
          notify
            message: '文章已创建'
            classes: 'alert-success'
          $state.go 'settings.myArticles'
        .catch (error) ->
          notify
            message: '创建文章出错啦：' + error
            classes: 'alert-danger'

  if !$state.params.articleId
    console.log 'new article'
    $scope.article = {}
    focus 'articleTitle'
  else
    Restangular.one('articles', $state.params.articleId).get()
    .then (article) ->
      $scope.article = article
      focus 'articleTitle'
    .catch (error) ->
      notify
        message: '文章不存在或者已经删除：' + error
        classes: 'alert-danger'
      $state.go 'settings.myArticles'
