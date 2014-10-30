'use strict'

angular.module('mauiApp')

.controller 'CategoryManagerCtrl', (
  $scope
  $state
  Categories
) ->

  viewFirstCategory = ->
    categories = $scope.categories
    $scope.viewCategory(categories[0]) if categories.length > 0

  angular.extend $scope,

    categories: Categories
    selectedCategory: null

    onCreateCategory: (category) ->
      $scope.categories.push category

    onDeleteCategories: (categories) ->
      angular.forEach categories, (c) ->
        $scope.categories.splice($scope.categories.indexOf(c), 1)

    viewCategory: (category) ->
      $state.go('admin.categoryManager.detail', categoryId:category._id)

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    viewFirstCategory() if toState.name == 'admin.categoryManager'
