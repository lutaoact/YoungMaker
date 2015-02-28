angular.module('mauiApp')

.controller 'ArticleDetailCtrl', (
  $scope
  $state
  Restangular
  $location
) ->

  angular.extend $scope,
    article: null
    group: null

    showWechatShareBtn: ()->
      window.WeixinJSBridge?

    wechatShare: ->
      wxShare.shareTimeline()

  Restangular
    .one('articles', $state.params.articleId)
    .get(viewer: true)
    .then (article) ->
      if !article
        $state.go '404', url : $state.href($state.current, $state.params),
          location:'replace'
        return
      $scope.article = article
      wxShare.init
        shareTitle: article.title
        descContent: article.info
        lineLink: $location.$$absUrl
      if article?.group?._id
        Restangular
          .one('groups', article.group._id)
          .get()
          .then (group) ->
            $scope.group = group
