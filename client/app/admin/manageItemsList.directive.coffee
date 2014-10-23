'use strict'

angular.module('budweiserApp')

.directive 'manageItemsList', ->
  restrict: 'EA'
  replace: true
  controller: 'ManageItemsListCtrl'
  templateUrl: 'app/admin/manageItemsList.html'
  scope:
    items: '='
    children: '@'
    itemType: '@'
    activeItem: '='
    onCreateItem: '&'
    onDeleteItems: '&'
    onViewItem: '&'

.controller 'ManageItemsListCtrl', (
  $modal
  $state
  $scope
  notify
  Restangular
) ->

  updateSelected = ->
    $scope.selectedItems =  _.filter($scope.items, '$selected':true)

  angular.extend $scope,
    $state: $state
    toggledSelectAllItems: false
    selectedItem: null
    selectedItems: []
    itemTitle:
      switch $scope.itemType
        when 'classes'    then '班级'
        when 'categories' then '科目'
        else throw 'unknown itemType ' + $scope.itemType

    deleteItems: (selectedItems) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        size: 'sm'
        resolve:
          title: -> "删除#{$scope.itemTitle}"
          message: ->
            """确认要删除这#{selectedItems.length}个#{$scope.itemTitle}？"""
      .result.then ->
        $scope.toggledSelectAllItems = false if $scope.toggledSelectAllItems
        $scope.deleting = true
        Restangular.all($scope.itemType).customPOST(ids: _.pluck(selectedItems, '_id'), 'multiDelete')
        .then ->
          $scope.deleting = false
          $scope.onDeleteItems?($items:selectedItems)

    createNewItem: ->
      $modal.open
        templateUrl: 'app/admin/newItemModal.html'
        controller: 'NewItemModalCtrl'
        size: 'sm'
        resolve:
          itemType: -> $scope.itemType
          itemTitle: -> $scope.itemTitle
      .result.then (newItem) ->
        $scope.onCreateItem?($item:newItem)
        notify
          message: "新#{$scope.itemTitle}添加成功"
          classes: 'alert-success'

    viewItem: (item) ->
      $scope.onViewItem?($item:item)

    toggleSelect: (items, selected) ->
      angular.forEach items, (o) -> o.$selected = selected
      updateSelected()

  $scope.$watch 'items', updateSelected
