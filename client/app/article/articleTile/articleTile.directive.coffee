'use strict'

angular.module('mauiApp').directive 'articleTile', ->
  restrict: 'EA'
  replace: true
  scope:
    me: '='
    article: '='
  templateUrl: (element, attrs) ->
    switch attrs.type
      when 'simple'
        'app/article/articleTile/articleTileSimple.html'
      else
        'app/article/articleTile/articleTile.html'

  controller: (
    $scope
    notify
    messageModal
  )->

    angular.extend $scope,

      removeArticle: (article) ->
        articleType = if article.group then '小组帖子' else '文章'
        messageModal.open
          title: -> '删除' + articleType
          message: -> "确定要删除该#{articleType}吗？"
        .result.then ->
          article.remove().then ->
            index = $scope.$parent.articles?.indexOf article
            $scope.$emit 'article.remove', article
            $scope.$parent.articles?.splice index, 1
            notify
              message: articleType + '已经删除'
              classes: 'alert-success'

