angular.module('mauiApp')

.controller 'ArticleEditorCtrl', (
  $q
  focus
  $scope
  $state
  notify
  $filter
  $window
  Restangular
) ->

  angular.extend $scope,
    title: null
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
            message: $scope.articleType + '已保存'
            classes: 'alert-success'
          $window.history.back()
        .catch (error) ->
          console.remote? error
          notify
            message: '出错啦：' + error
            classes: 'alert-danger'
      else
        Restangular.all('articles')
        .post($scope.article)
        .then ->
          notify
            message: $scope.articleType + '发表成功'
            classes: 'alert-success'
          if $state.params.groupId?
            $state.go 'groupDetail.articleList', groupId: $state.params.groupId
          else
            $state.go 'user.articles', userId: $scope.me._id

  $q (resolve, reject) ->
    if $state.params.articleId
      Restangular.one('articles', $state.params.articleId).get()
      .then resolve
      .catch reject
    else
      resolve group:$state.params.groupId
  .then (article) ->
    $scope.articleType = if article.group then '帖子' else '文章'
    $scope.articleAction = if article._id then '编辑' else '发表'
    $scope.article = article
    focus 'articleTitle'
  .catch (error) ->
    notify
      message: '该内容不存在或者已经删除：' + error
      classes: 'alert-danger'
