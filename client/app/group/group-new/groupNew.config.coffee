angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'groupNew',
    url: '/groups/new'
    templateUrl: 'app/group/group-new/group-new.html'
    controller: 'GroupNewCtrl'

