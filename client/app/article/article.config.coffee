angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'article',
    url: '/articles/:articleId'
    templateUrl: 'app/article/article.html'
    controller: 'ArticleCtrl'