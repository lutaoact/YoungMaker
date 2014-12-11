angular.module('mauiApp')

.controller 'ArticleListCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    me: Auth.getCurrentUser
    groupes  : []
    articles : []

    likeClick: (article) ->
      article.customPOST(null, 'like')
      .then (newArticle) ->
        article.likeUsers = newArticle.likeUsers

    createArticle: ->
      Restangular.all('articles').post
        title: '新建话题'
        content: ''
      .then (article) ->
        $state.go 'articleEditor', articleId: article._id

  Restangular.all('groups').getList()
  .then (groups) ->
    $scope.groups = groups

  Restangular.all('articles').getList()
  .then (articles) ->
    $scope.articles = articles
