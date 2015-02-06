angular.module('mauiApp')

.controller 'ArticleEditorCtrl', (
  focus
  $scope
  $state
  notify
  $filter
  Restangular
) ->

  angular.extend $scope,
    article: null

    saveArticle: (form) ->
      if !form.$valid then return
      if _.isEmpty $scope.article.content
        focus 'articleContent'
        return

      # Get First Image
      images = $filter('images')($scope.article.content)
      $scope.article.image = images[0]?.src

      if $scope.article._id
        Restangular.one('articles', $scope.article._id)
        .patch $scope.article
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
      else
        Restangular.all('articles')
        .post($scope.article)
        .then ->
          notify
            message: '话题已创建'
            classes: 'alert-success'
          if $state.params.groupId?
            $state.go 'groupDetail.articleList', groupId: $state.params.groupId
          else
            $state.go 'user.home', userId: $scope.me._id

    deleteArticle: ->
      $scope.article.remove().then ->
        history.go(-2)

  if $state.params.articleId
    Restangular.one('articles', $state.params.articleId).get()
    .then (article) ->
      $scope.article = article
      focus 'articleTitle'
    .catch (error) ->
      notify
        message: '话题不存在或者已经删除：' + error
        classes: 'alert-danger'
  else
    $scope.article =
      group: $state.params.groupId
