angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'groupNew',
    url: '/groups/new'
    templateUrl: 'app/group/groupNew/groupNew.html'
    controller: 'GroupNewCtrl'

  .state 'groupDetail',
    url: '/groups/:groupId'
    templateUrl: 'app/group/groupDetail/groupDetail.html'
    controller: 'GroupDetailCtrl'
    abstract: true

  .state 'groupDetail.articleList',
    url: '?page&keyword&sort'
    templateUrl: 'app/group/groupDetail/groupArticleList.html'
    controller: 'GroupArticleListCtrl'

  .state 'groupDetail.memberList',
    url: '/members'
    templateUrl: 'app/group/groupMemberList/groupMemberList.html'
    controller: 'GroupMemberListCtrl'

  .state 'groupArticleNew',
    url: '/groups/:groupId/articles/new'
    templateUrl: 'app/article/articleEditor/articleEditor.html'
    controller: 'ArticleEditorCtrl'
    authenticate: true

  .state 'groupArticleDetail',
    url: '/groups/articles/:articleId'
    templateUrl: 'app/article/articleDetail/articleDetail.html'
    controller: 'ArticleDetailCtrl'

  .state 'groupList',
    url: '/groups?page&keyword&sort=postsCount'
    templateUrl: 'app/group/groupList/groupList.html'
    controller: 'GroupListCtrl'