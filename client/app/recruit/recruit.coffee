angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'recruit',
    url: '/recruit'
    templateUrl: 'app/recruit/recruit.html'

