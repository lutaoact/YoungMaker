'use strict'

angular.module('budweiserApp')

.controller 'CategoryManagerCtrl', (
  $scope
  $modal
  Restangular
) ->

  angular.extend $scope,

    categories: null
    category: {}

    reloadCategories: ->
      Restangular.all('categories').getList()
      .then (categories) ->
        $scope.categories = categories

    addCategory: ->
      $scope.categories.post $scope.category
      .then $scope.reloadCategories

    removeCategory: (category) ->
      $modal.open
        templateUrl : 'components/modal/MessageModal.html'
        controller : 'MessageModalCtrl'
        size: 'sm'
        resolve :
          title : -> '确认删除学科 '+category.name
          message : -> """删除学科可能导致已有课程丢失学科信息，确定要删除此学科吗？"""
      .result.then ->
        category.remove().then $scope.reloadCategories

  $scope.reloadCategories()
