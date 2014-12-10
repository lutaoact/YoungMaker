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

    likeClick: (article) ->
      Restangular.one('articles', article._id).customPOST(null, 'like')
      .then (dbArticle) ->
        angular.extend article, dbArticle

  Restangular.one('users', $state.params.userId).get()
  .then (user) ->
    $scope.user = user

  $q.all [
    Restangular.all('articles').getList(author: $state.params.userId)
    .then (articles) ->
      $scope.articles = articles
  ,
    Restangular.all('courses').getList(author: $state.params.userId)
    .then (courses) ->
      $scope.courses = courses
  ]
  .then ->
    if $scope.articles.length && !$scope.courses.length
      $scope.articles.$active = true
