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
      $scope.article.save()
      .then (article) ->
        angular.extend $scope.article, article
        notify
          message: '话题已保存'
          classes: 'alert-success'
      .catch (error) ->
        console.log error
        notify
          message: '保存话题出错啦：' + error
          classes: 'alert-danger'

    deleteArticle: ->
      $scope.article.remove().then ->
        $state.go('user', userId:$scope.article.author._id)

  Restangular.one('articles', $state.params.articleId).get()
  .then (article) ->
    $scope.article = article
    focus 'articleTitle'
  .catch (error) ->
    notify
      message: '话题不存在或者已经删除：' + error
      classes: 'alert-danger'
