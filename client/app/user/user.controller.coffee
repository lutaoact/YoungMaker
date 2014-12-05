'use strict'

angular.module('mauiApp')

.controller 'UserCtrl', (
  $scope
  $state
) ->

  console.debug 'user ...'

  angular.extend $scope,
    $state: $state
    user: null
    articles: []
    comments: []


