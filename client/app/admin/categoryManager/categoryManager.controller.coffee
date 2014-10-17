'use strict'

angular.module('budweiserApp').controller 'CategoryManagerCtrl', (
  $scope
  $modal
  Restangular
) ->

  angular.extend $scope,

    categories: Restangular.all('categories').getList().$object
    category: {}

    addCategory: ->
      $scope.categories.post $scope.category
      .then (cat) ->
        $scope.category = {}
        $scope.categories.push cat

    removeCategory: (cat) ->
      $modal.open
        templateUrl : 'components/modal/MessageModal.html'
        controller : 'MessageModalCtrl'
        resolve :
          title : -> '确认删除学科 '+cat.name
          message : -> """删除学科可能导致已有课程丢失学科信息，确定要删除此学科吗？"""
      .result.then ->
        cat.remove().then ->
          index = $scope.categories.indexOf cat
          $scope.categories.splice index, 1

