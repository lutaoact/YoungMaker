'use scrict'

angular.module('budweiserApp').controller 'NewItemModalCtrl', (
  $scope
  itemType
  itemTitle
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    itemTitle: itemTitle
    item:
      name: ''

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      Restangular.all(itemType).post($scope.item)
      .then $modalInstance.close