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
    me: Auth.getCurrentUser
    user: null
    $state: $state
    courses  : []
    articles : []
    comments : []

    removeArticle: (article) ->
      article.remove().then ->
        index = $scope.articles.indexOf article
        $scope.articles.splice index, 1
        notify
          message: '文章已经删除'
          classes: 'alert-success'

    createArticle: ->
      Restangular.all('articles').post
        title: '未命名的文章'
      .then (article) ->
        $state.go 'edit-article', articleId: article._id

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
