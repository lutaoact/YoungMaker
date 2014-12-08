'use strict'

angular.module('mauiApp')

.controller 'UserCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    $state: $state
    me: Auth.getCurrentUser()
    user: Restangular.one('users', $state.params.userId).get().$object
    articles: Restangular.all('articles').getList(author: $state.params.userId).$object
    comments: []


