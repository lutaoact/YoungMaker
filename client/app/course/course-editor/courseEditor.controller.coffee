angular.module('mauiApp')

.controller 'CourseEditorCtrl', (
  Auth
  $scope
  $state
  Restangular
  CurrentUser
) ->

  angular.extend $scope,
    article: {}

    saveArticle: (form) ->
      console.debug form
      if !form.$valid then return
      $scope.article.author = CurrentUser._id
      Restangular.all('articles').post($scope.article)
      .then ->
        $state.go 'settings.myArticles'
      .catch (error) ->
        console.log 'error', error

