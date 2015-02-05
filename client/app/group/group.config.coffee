angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'groupNew',
    url: '/groups/new'
    templateUrl: 'app/group/groupNew/groupNew.html'
    controller: 'GroupNewCtrl'

  .state 'group',
    url: '/groups/:groupId?page&keyword'
    templateUrl: 'app/group/group.html'
    controller: 'GroupCtrl'

  .state 'groupArticleNew',
    url: '/groups/:groupId/articles/new'
    templateUrl: 'app/article/articleEditor/articleEditor.html'
    controller: 'ArticleEditorCtrl'
    authenticate: true

  .state 'groupList',
    url: '/groups?page&keyword&sort=postsCount'
    templateUrl: 'app/group/groupList/groupList.html'
    controller: 'GroupListCtrl'