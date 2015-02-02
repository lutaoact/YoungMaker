angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'groupNew',
    url: '/groups/new'
    templateUrl: 'app/group/groupNew/groupNew.html'
    controller: 'GroupNewCtrl'

  .state 'group',
    url: '/groups/:groupId'
    templateUrl: 'app/group/group.html'
    controller: 'GroupCtrl'

  .state 'groupArticleEditor',
    url: '/groups/:groupId/articles/:articleId/edit'
    templateUrl: 'app/article/article-editor/article-editor.html'
    controller: 'ArticleEditorCtrl'
    authenticate: true

  .state 'groupArticleDetail',
    url: '/groups/:groupId/articles/:articleId'
    templateUrl: 'app/article/article-detail/article-detail.html'
    controller: 'ArticleDetailCtrl'

  .state 'groupList',
    url: '/groups'
    templateUrl: 'app/group/groupList/groupList.html'
    controller: 'GroupListCtrl'