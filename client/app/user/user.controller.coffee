'use strict'

angular.module('mauiApp')

.controller 'UserCtrl', (
  $q
  Auth
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    me: Auth.getCurrentUser()
    user: null
    $state: $state
    courses  : []
    articles : []
    comments : []

  Restangular.one('users', $state.params.userId).get()
  .then (user) ->
    $scope.user = user

  $q.all [
    Restangular.all('articles').getList(author: $state.params.userId)
    .then (articles) ->
      console.log articles
      $scope.articles = articles
  ,
    Restangular.all('courses').getList(author: $state.params.userId)
    .then (courses) ->
      $scope.courses = courses
  ]
  .then ->
    if $scope.articles.length && !$scope.courses.length
      $scope.articles.$active = true
