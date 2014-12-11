angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'group',
    url: '/groups/:groupId'
    templateUrl: 'app/group/group.html'
    controller: 'GroupCtrl'

