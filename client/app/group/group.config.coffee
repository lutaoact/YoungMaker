angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'group',
    url: '/groups/:groupId'
    templateUrl: 'app/group/group.html'
    controller: 'GroupCtrl'

  .state 'groupArticleEditor',
    url: '/groups/:groupId/articles/:articleId/edit'
    templateUrl: 'app/article/article-editor/article-editor.html'
    controller: 'ArticleEditorCtrl'
    authenticate: true