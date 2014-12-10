angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'articleList',
    url: '/topics'
    templateUrl: 'app/article/article-list/article-list.html'
    controller: 'ArticleCtrl'
