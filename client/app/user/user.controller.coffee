'use strict'

angular.module('mauiApp')

.controller 'UserCtrl', (
  $q
  Auth
  $scope
  $state
  notify
  Restangular
) ->

  angular.extend $scope,
    me: Auth.getCurrentUser
    user: null
    $state: $state
    courses  : []
    articles : []
    comments : []

    likeClick: (article) ->
      article.customPOST(null, 'like')
      .then (dbArticle) ->
        article.likeUsers = dbArticle.likeUsers

    removeArticle: (article) ->
      article.remove().then ->
        index = $scope.articles.indexOf article
        $scope.articles.splice index, 1
        notify
          message: '话题已经删除'
          classes: 'alert-success'

    createArticle: ->
      Restangular.all('articles').post
        title: '新建话题'
        content: ''
      .then (article) ->
        $state.go 'article-edit', articleId: article._id

    createCourse: ->
      $state.go 'courseEditor'

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
    else
      $scope.courses.$active = true
