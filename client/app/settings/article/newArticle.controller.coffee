angular.module('mauiApp')

.controller 'NewArticleCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    article: {}

    saveArticle: (form) ->
      console.debug form
      if !form.$valid then return
      $scope.article.author = Auth.getCurrentUser()._id
      Restangular.all('articles').post($scope.article)
      .then ->
        $state.go 'settings.myArticles'
      .catch (error) ->
        console.log 'error', error

