angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'article-detail',
    url: '/articles/:articleId'
    templateUrl: 'app/article/article-detail/article-detail.html'
    controller: 'ArticleDetailCtrl'

  .state 'article-edit',
    url: '/articles/:articleId/edit'
    templateUrl: 'app/article/article-edit/article-edit.html'
    controller: 'ArticleEditCtrl'
    authenticate: true
