'use scrict'

angular.module('budweiserApp').controller 'NewItemModalCtrl', (
  $scope
  itemType
  itemTitle
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    errors: null
    itemTitle: itemTitle
    item:
      name: ''

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      $scope.errors = null
      Restangular.all(itemType).post($scope.item)
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors