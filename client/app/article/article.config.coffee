angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'articleDetail',
    url: '/articles/:articleId'
    templateUrl: 'app/article/article-detail/article-detail.html'
    controller: 'ArticleDetailCtrl'

  .state 'articleEditor',
    url: '/articles/:articleId/edit'
    templateUrl: 'app/article/article-editor/article-editor.html'
    controller: 'ArticleEditorCtrl'
    authenticate: true
