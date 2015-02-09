'use strict'

angular.module('mauiApp').directive 'articleTile', ->
  templateUrl: 'app/article/articleTile/articleTile.html'
  restrict: 'EA'
  replace: true
  scope:
    me: '='
    article: '='
  link: (scope, element, attrs) ->

  controller: ($scope, notify, messageModal)->

    angular.extend $scope,
      stopPropagation: ($event)->
        $event.stopPropagation()

      toggleCollect: ()->
        $scope.article.one('like').post()
        .then (res)->
          $scope.article.likeUsers = res.likeUsers

      removeArticle: (article) ->
        messageModal.open
          title: -> '删除话题'
          message: -> '确定要删除该话题吗？'
        .result.then ->
          article.remove().then ->
            index = $scope.$parent.articles?.indexOf article
            $scope.$emit 'article.remove', article
            $scope.$parent.articles?.splice index, 1
            notify
              message: '话题已经删除'
              classes: 'alert-success'

