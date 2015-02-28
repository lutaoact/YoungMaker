angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'articleNew',
    url: '/articles/new'
    templateUrl: 'app/article/articleEditor/articleEditor.html'
    controller: 'ArticleEditorCtrl'
    authenticate: true

  .state 'articleDetail',
    url: '/articles/:articleId?commentId'
    templateUrl: 'app/article/articleDetail/articleDetail.html'
    controller: 'ArticleDetailCtrl'

  .state 'articleEditor',
    url: '/articles/:articleId/edit'
    templateUrl: 'app/article/articleEditor/articleEditor.html'
    controller: 'ArticleEditorCtrl'

  .state 'articleList',
    url: '/articles?page&keyword&sort&tags'
    templateUrl: 'app/article/articleList/articleList.html'
    controller: 'ArticleListCtrl'
