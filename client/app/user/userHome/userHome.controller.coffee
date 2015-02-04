'use strict'

angular.module('mauiApp')

.controller 'UserHomeCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    courses  : []
    articles : []
    comments : []

    createArticle: ->
      $state.go 'articleNew'

    createCourse: ->
      $state.go 'courseEditor'

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
    else
      $scope.courses.$active = true
