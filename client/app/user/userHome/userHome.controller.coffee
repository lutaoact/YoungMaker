'use strict'

angular.module('mauiApp')

.controller 'UserHomeCtrl', (
  $q
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    courses: []
    articles: []
    activities: []

    createArticle: ->
      $state.go 'articleNew'

    createCourse: ->
      $state.go 'courseEditor'

  $q.all [
    Restangular
      .all('activities')
      .getList()
      .then (activities) ->
        $scope.activities = activities
  ,
    Restangular
      .all('articles')
      .getList(author: $state.params.userId)
      .then (articles) ->
        $scope.articles = articles
  ,
    Restangular
      .all('courses')
      .getList(author: $state.params.userId)
      .then (courses) ->
        $scope.courses = courses
  ]
  .then ->
    if $scope.activities.length
      $scope.activities.$active = true
      return
    if $scope.articles.length
      $scope.articles.$active = true
      return
    if $scope.courses.length
      $scope.courses.$active = true
      return
