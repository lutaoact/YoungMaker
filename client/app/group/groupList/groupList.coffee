angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'groupList',
    url: '/groups'
    templateUrl: 'app/group/groupList/groupList.html'
    controller: 'GroupListCtrl'
