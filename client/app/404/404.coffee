angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state '404',
    url: '404?url'
    templateUrl: 'app/404/404.html'
    controller: ($scope, $state)->
      $scope.prevUrl = $state.params.url

