'use strict'

angular.module('mauiApp').directive 'articleTile', ->
  templateUrl: 'app/article/articleTile/articleTile.html'
  restrict: 'EA'
  replace: true
  scope:
    me: '='
    article: '='
  link: (scope, element, attrs) ->

  controller: ($scope, notify)->

    angular.extend $scope,
      stopPropagation: ($event)->
        $event.stopPropagation()

      toggleVote: ()->
        $scope.article.one('like').post()
        .then (res)->
          $scope.article.likeUsers = res.likeUsers

      toggleCollect: ()->
        $scope.article.one('like').post()
        .then (res)->
          $scope.article.likeUsers = res.likeUsers

      removeArticle: (article) ->
        article.remove().then ->
          index = $scope.$parent.articles?.indexOf article
          $scope.$emit 'article.remove', article
          $scope.$parent.articles?.splice index, 1
          notify
            message: '话题已经删除'
            classes: 'alert-success'

